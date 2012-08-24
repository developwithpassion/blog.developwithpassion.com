---
layout: post
title: "Excel Formatting with Visitors, Specifications, and Composites"
comments: true
date: 2008-12-10 09:00
categories:
- c sharp
- programming
---

The title is definitely a mouthful!!  
A project a year ago (yep, I’m quite behind on the technical blogging front) required the need for Excel generation and formatting. Unlike other Excel generation tasks I had done in the past, this particular task called for generation of tabbed workbooks, with graphs, fancy formatting etc. Much more involved than the trivial stuff I had typically done with excel in the past.  
Applying formatting to elements in a tree is a perfect job for the Visitor pattern!! Of course, different types of formatting need to be applied to different cells, some cells need multiple types of formatting applied to them. Composite pattern can come to the rescue here. How can we filter out different types of formatting to certain cells / range of cells? The Specification pattern can come in handy here.  
The project resulted in the creation of a fairly flexible excel formatting engine (that has been run against 3rd party excel frameworks SpreadSheetGear, and OfficeWriter).  
Here is the interface for a cell visitor:  
  
{% codeblock lang:csharp %}
public interface ICellVisitor
{
    void visit(IRange cell);
}
{% endcodeblock %}





And here is the implementation for the composite visitor:

{% codeblock lang:csharp %}
public class CompositeCellVisitor : ICellVisitor
{
    private IList<ICellVisitor> all_visitors;

    public CompositeCellVisitor()
    {
        all_visitors = new List<ICellVisitor>();
    }

    public void add(ICellVisitor visitor)
    {
        all_visitors.Add(visitor);
    }

    public void add_all(IEnumerable<ICellVisitor> visitors)
    {
        foreach (var visitor in visitors) add(visitor);
    }


    public void visit(IRange cell)
    {
        foreach (var visitor in all_visitors) visitor.visit(cell);
    }
}
{% endcodeblock %}



As you can see, a composite basically implements the same interface as the things it is being composed of and it simply (for the most part) does its job by delegating to each of its leaf items to do their jobs. In this case, each visitor is told to visit a cell. This means that when an iterator for a spreadsheet (which essentially makes sure to walk over each cell in the spreadsheet) walks to a certain cell, it can then tell the CompositeVisitor to visit the cell. Because the composite is composed of all the possible visitors that can visit a cell, you only need to pass through the spreadsheet once to apply all formatting.

Here are the names of some of the formatting that can be done:

* ApplyAllCellBorders 
* AutoFitCellWidth
* BoldFont
* ChangeFontSize
* CustomFormat
* FormatBackColor


Here is the implementation of one of the visitors:

{% codeblock lang:csharp %}
public class FormatBackColor : ICellVisitor 
{
  private Color color;
  public FormatBackColor(Color color) 
  {
    this.color = color;
  }

  public void visit(IRange cell) 
  {
    cell.Interior.Color = color;
  }
}
{% endcodeblock %}



As you see, the visitor is only responsible for a single discrete action. It has no knowledge as to whether or not it should actually apply itself against a cell, it just goes ahead and applies itself. This would obviously cause problems as there needs to be a way to allow a Visitor to visit/not visit a cell, without necessarily giving the visit the extra responsibility of making that determination. To accomodate this I separated responsibilities (matching/visiting) by “favouring composition” here is a class that was created to solve this problem in an SRP fashion:





{% codeblock lang:csharp %}
public class ConstrainedCellVisitor : ICellVisitor
{
    private ICellVisitor cell_visitor;
    private ISpecification<IRange> constraint;

    public ConstrainedCellVisitor(ICellVisitor cell_visitor, ISpecification<IRange> constraint)
    {
        this.cell_visitor = cell_visitor;
        this.constraint = constraint;
    }

    public void visit(IRange cell)
    {
        if (constraint.is_satisfied_by(cell)) cell_visitor.visit(cell);
    }
}
{% endcodeblock %}



The ConstrainedCellVisitor is composed of a raw visitor (that will perform an action against the cell) as well as the specification that will determine whether the cell in questions meets the criteria to be visited with the actual concrete formatting visitor.


The specification interface is something I am sure you have seen me use before (lots of usages, different contexts):




{% codeblock lang:csharp %}
public interface ISpecification<T>
{
    bool is_satisfied_by(T item);
}
{% endcodeblock %}


All that is needed to finish it off is a very simple configuration api to configure visitors with specifications. Here is one example of a line that builds a visitor and a specification:




{% codeblock lang:csharp %}
yield return new ConstrainedCellVisitor(new ChangeFontSize(8),Cell.occurs_between_columns(3, 8).and(Cell.occurs_after_row(5)) .or(Cell.is_named("P3")));
{% endcodeblock %}






With this model, the ability to add new formatting needs was as simple as adding a new visitor that was only concerned with a specific formatting. This allowed for the incremental growth of formatting visitors as the report demanded it.


This is just one example of where using the power of composition and a couple of “seemingly” simple patterns, can yield results that are extremely extensible results. IMHO the Command and Visitor patterns are 2 of the most powerful and highly underused design patterns a developer has in their toolkit (of course, like with any design pattern, you need to use them wisely).


Develop With Passion!!


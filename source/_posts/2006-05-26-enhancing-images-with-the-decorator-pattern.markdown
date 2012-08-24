---
layout: post
title: "Enhancing Images With The Decorator Pattern"
comments: true
date: 2006-05-26 09:00
categories:
- .net 2.0
- c sharp
- patterns
---

I have been thinking for a while about coming up with a series of posts that talk about real world applications of many of the design patterns that get thrown around. I have been meaning to post about the decorator pattern for quite some time. I was trying to come up with an example that would practically demonstrate the Decorator pattern and then it hit me. An image browser. Here is the sample app in action: 

<a href="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/MainForm.jpg" rel="lightbox[enhancingimageswiththedecoratorpattern]"><img alt="MainForm" src="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/MainForm_thumb.jpg" align="left" border="0" / / / /></a>

<a href="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/OpenDialog.jpg" rel="lightbox[enhancingimageswiththedecoratorpattern]"><img alt="OpenDialog" src="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/OpenDialog_thumb2.jpg" border="0" / / / /></a><a href="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/ViewingPlainImage.jpg" rel="lightbox[enhancingimageswiththedecoratorpattern]"><img alt="ViewingPlainImage" src="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/ViewingPlainImage_thumb1.jpg" border="0" / / / /></a>

As you can see, it is pretty standard fare. When the button is clicked, a file dialog browser will pop-up and the user will have the option to choose a file to display. If they pick a file the file will be displayed. If they don't pick a file nothing will happen. The code-behind for the form is pretty simple:



{% codeblock lang:csharp %}
public partial class ImageBrowser : Form, IImageBrowserView 
{ 
  private OpenFileDialog openFileDialog; 
  private ImageBrowserPresenter presenter; 
  public ImageBrowser() 
  { 
    InitializeComponent(); 
    presenter = new ImageBrowserPresenter(this); 
    openFileDialog = new OpenFileDialog(); 
    HookupEventHandlers(); 
  } 
  private void HookupEventHandlers() 
  { 
    this.retrieveImageButton.Click += delegate  { presenter.DisplayImage(); }; 
  } 
  public bool WatermarkRequired 
{ get 
  { return watermarkCheckBox.Checked; } 
} 
public string ImagePath 
{ get  
  { 
    openFileDialog.ShowDialog(); 
    return openFileDialog.FileName; 
  } 
} 
public void Display(Image image) 
{ 
  this.pictureBox.Image = image; 
} 
}  
{% endcodeblock %}



As you can see, I am using the model view presenter, and the presenter has the responsibility of pushing an image to the view that the view will display. This article is not about the MVP so try not to get too hung up on it if you have not seen it before. As you can see from the code, the main work will be performed inside the DisplayImage method of the presenter. The code for the presenter turns out to be very trivial: 

{% codeblock lang:csharp %}
public class ImageBrowserPresenter
{
    private IImageBrowserView view;

    public ImageBrowserPresenter(IImageBrowserView view)
    {
        this.view = view;
    }

    public void DisplayImage()
    {
        string pathOfImageToDisplay = view.ImagePath;
        if (IsValid(pathOfImageToDisplay))
        {                
            view.Display(Bitmap.FromFile(pathOfImageToDisplay));
        }
    }

    private bool IsValid(string imagePath)
    {
        return !string.IsNullOrEmpty(imagePath);    
    }
    
}
{% endcodeblock %}




So what is going on here. When the view tells the presenter to 'DisplayImage', the presenter turns back around to the view and asks it for the path of the image that it should display:

{% codeblock lang:csharp %}
string pathOfImageToDisplay = view.ImagePath;
{% endcodeblock %}





The view (form) responds to this request by popping up a file open dialog and returning the filename of the dialog to the presenter:

 

{% codeblock lang:csharp %}
public string ImagePath
{
    get
    {
        openFileDialog.ShowDialog();
        return openFileDialog.FileName;
    }
}
{% endcodeblock %}





The code in the form is actually feature complete for this example. There will be no changes required to make to the code behind to support new functionality (for this scenario). A scenario that people often run into for commercial web sites it needing to apply a water mark to an image so that people cannot just download their images and use them as their own. This is our first perfect candidate for the decorator pattern. We want to 'Decorate' an image with a watermark, that brands it as our own. 

<strong><u>What is the Decorator Pattern</u></strong>

Simply (and the decorator is a very simple,elegant pattern) the Decorator pattern allows us to attach additional responsibilities/behaviours to an object without the need for subclassing. The following class diagram shows the structure of a typical decorator implementation:

<img alt="Decorator" src="{{ site.cdn_root }}binary/enhancingImagesWithTheDecoratorPattern/decorator.gif" align="middle" border="0" / / / />(taken from [DoFactory.com](http://www.dofactory.com/))

One of the principles of the decorator pattern ensures that to the client, a decorator looks no different that the object it is decorating. In this scenario we want to decorate Images. The base class for Images in the framework (Bitmaps and Metafiles) is the System.Drawing.Image class. Unfortunately I can't inherit from this as the constructor for an Image is internal. I also can't inherit from Bitmap as that class is sealed. How can I decorate when I can't create a Decorator that implements the same interface as the object it is decorating. Adding a small layer of indirection will solve this problem:

 

{% codeblock lang:csharp %}
public interface ICoreImage 
{ 
  Image Picture { get; } 
} 
{% endcodeblock %}




I now have an interface that can be implemented by a class that really just wraps an image:

 

{% codeblock lang:csharp %}
public class CoreImage : ICoreImage
{
    private Image image;

    public CoreImage(Image image)
    {
        this.image = image;
    }
    
    public Image Picture
    {
        get { return image; }
    }
}
{% endcodeblock %}





As the saying goes "Another layer of indirection will solve any problem!!, now I have an interface that can be readily implemented by any class. Now, I promised that no changes would affect the code-behind of the form in anyway. To make use of this new class, I just need to change the presenter a little:

{% codeblock lang:csharp %}
public void DisplayImage()
{
    string pathOfImageToDisplay = view.ImagePath;
    if (IsValid(pathOfImageToDisplay))
    {                
        view.Display(GetImageFrom(pathOfImageToDisplay).Picture);
    }
}

private ICoreImage GetImageFrom(string pathOfImageToDisplay)
{
    return new CoreImage(Bitmap.FromFile(pathOfImageToDisplay));
}
{% endcodeblock %}



All I have done is introduced a method into the presenter that will retrieve an ICoreImage from a filename. Once the DisplayImage method retrieves the ICoreImage, it invokes the Picture property to return image data to the view. The current model of the application looks as follows:

<A href="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/initialmodel.jpg" rel=lightbox[enhancingimageswiththedecoratorpattern]><IMG alt=initialmodel src="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/initialmodel.jpg" border=0></A>

We now have to deal with a new requirement. When the user has the 'Watermark' checkbox checked, the image should display with a watermark rendered on it. To accomplish this new requirement we can come up with a decorator that will add the watermark to the image it is decorating. In this scenario I am only going to utilize a text based watermark. Options for a Watermark are encapsulated in a class called WatermarkOptions:

{% codeblock lang:csharp %}
public class WatermarkOptions
{
    private const int DEFAULT_SIZE = 26;
    private static readonly Font DEFAULT_FONT = new Font("Consolas", DEFAULT_SIZE, FontStyle.Bold, GraphicsUnit.Point);
    
    private Color color;
    private Font font;
    private string watermarkText;
    private Brush brush;
    private StringFormat format;
    
    public WatermarkOptions():this(DEFAULT_FONT,"SAMPLE",new StringFormat(StringFormatFlags.FitBlackBox),new SolidBrush(Color.Red))
    {
    }

    public WatermarkOptions(Font font, string watermarkText,StringFormat format,Brush brush)
    {            
        this.font = font;
        this.watermarkText = watermarkText;
        this.format = format;
        this.brush = brush;
    }     

    public Font Font
    {
        get { return font; }
    }

    public string WatermarkText
    {
        get { return watermarkText; }
    }

    public Brush Brush
    {
        get { return brush; }
    }

    public StringFormat Format
    {
        get { return format; }
    }
}
{% endcodeblock %}




As you can see, all this class contains is different settings for a watermark. Notice the use of the overloaded constructor, which allows people to construct a watermark and settle with defaults. To make use of this class we will create a 'WatermarkDecorator'. The decorator (from the clients point of view) has to look the same as the object it is decorating. In our case, the client is the 'DisplayImage' method of the presenter. Because we have the ICoreImage interface, I can utilize it to create the WatermarkDecorator:

{% codeblock lang:csharp %}
public class WatermarkDecorator : ICoreImage
{
    private const int BORDER = 4;
    private ICoreImage coreImageToWatermark;
    private readonly WatermarkOptions options;

    public WatermarkDecorator(ICoreImage coreImageToWatermark) : this(coreImageToWatermark, new WatermarkOptions())
    {
    }

    public WatermarkDecorator(ICoreImage coreImageToWatermark, WatermarkOptions options)
    {
        this.coreImageToWatermark = coreImageToWatermark;
        this.options = options;
    }

    public Image Picture
    {
        get { return DecorateWithWatermark(coreImageToWatermark.Picture); }
    }

    private Image DecorateWithWatermark(Image picture)
    {
        using (Graphics graphics = Graphics.FromImage(picture))
        {                
            SizeF textSize = graphics.MeasureString(options.WatermarkText, options.Font, picture.Width - BORDER, options.Format);
            RectangleF textRectangle = new RectangleF(BORDER, BORDER, picture.Width, textSize.Height);
            graphics.DrawString(options.WatermarkText, options.Font, options.Brush, textRectangle, options.Format);
            graphics.Flush();             
            return picture;
        }
    }
}
{% endcodeblock %}



Now you can see the Decorator pattern in action. Decorators always need to know about the object they are adding behaviour/functionality to, a great way to accomplish this is through constructor injection. When constructed with only an image, the decorator makes use of the parameterless WatermarkOptions constructor, to create options with default settings. Remember, decorators are adding new functionality to existing objects at runtime, the magic of adding the watermark happens when the Picture property on the decorator gets invoked. Instead of just immediately delegating to the object being decorated, it invokes the 'DecorateWithWatermark' method, passing in the image retrieved from the underlying 'decorated' ICoreImage. The DecorateWithWatermark method contains the logic to apply a watermark to the image, making use of the WatermarkOptions that got passed in. I am not going to delve into the details of the graphics jargon, for the most part it is pretty simple.

Ok, so I have this decorator, how do I use it? Switching back to the method in the presenter that actually instantiates the CoreImage, I can apply the decorator quickly by performing a quick check as to whether the user wants Watermarks applied:

 

{% codeblock lang:csharp %}
   private ICoreImage GetImageFrom(string pathOfImageToDisplay) 
   { 
     ICoreImage image = new CoreImage(Bitmap.FromFile(pathOfImageToDisplay)); 
     return (view.WatermarkRequired ? new WatermarkDecorator(image) : image);
    } 
{% endcodeblock %}





You will note that the DisplayImage method in the presenter did not need to change at all, why? Because all it cared about was when it called the GetImageFrom method, was that it received an ICoreImage implementation, it doesn't know or care if it is a decorator. If I run the application now any files that are opened while the checkbox is checked will have a watermark drawn over them:

<A href="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/imageshownwithwatermark.jpg" rel=lightbox[enhancingimageswiththedecoratorpattern]><IMG alt=imageshownwithwatermark src="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/imageshownwithwatermark_thumb.jpg" border=0></A>

Our revised class diagram looks like so:

<A href="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/revisedmodel.jpg" rel=lightbox[enhancingimageswiththedecoratorpattern]><IMG alt=revisedmodel src="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/revisedmodel.jpg" border=0></A>

To finish off, a decorator also doesn't care what it is decorating either, as long as the object that it is decorating implements the same interface as what it does. So if the customer came to you all of a sudden and said 'Regardless of whether the image has a watermark or not, we want a border around all images', you could satisfy that requirement with another discrete decorator:

 

{% codeblock lang:csharp %}
public class BorderDecorator : ICoreImage
{
    private const int PEN_WIDTH = 10;
    private ICoreImage imageToDecorate;

    public BorderDecorator(ICoreImage imageToDecorate)
    {
        this.imageToDecorate = imageToDecorate;
    }

    public Image Picture
    {
        get { return WrapWithBorder(imageToDecorate.Picture); }
    }

    private Image WrapWithBorder(Image picture)
    {
        using (Graphics graphics = Graphics.FromImage(picture))
        {
            RectangleF border = new RectangleF(0, 0, picture.Size.Width, picture.Size.Height);
            Pen pen = new Pen(new SolidBrush(Color.Black), PEN_WIDTH);
            graphics.DrawRectangle(pen,border.X,border.Y,border.Width,border.Height);
            graphics.Flush();
        }
        return picture;
    }
}
{% endcodeblock %}






To ensure that all images have borders, I can just apply the new decorator to the existing decorator!!:

 

{% codeblock lang:csharp %}
private ICoreImage GetImageFrom(string pathOfImageToDisplay) 
{ 
  ICoreImage image = new CoreImage(Bitmap.FromFile(pathOfImageToDisplay)); 
  return new BorderDecorator(view.WatermarkRequired ? new WatermarkDecorator(image) : image); } 
{% endcodeblock %}






With that change applied, if I run the application now, all images (watermarked or not) will have a border around them: 

<A href="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/plainimagewithborder.jpg" rel=lightbox[enhancingimageswiththedecoratorpattern]><IMG alt=plainimagewithborder src="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/plainimagewithborder_thumb.jpg" border=0></A>  <A href="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/watermarkedimagewithborder.jpg" rel=lightbox[enhancingimageswiththedecoratorpattern]><IMG alt=watermarkedimagewithborder src="{{ site.cdn_root }}binary/enhancingimageswiththedecoratorpattern/watermarkedimagewithborder_thumb1.jpg" border=0></A>

Now of course. In this example I had the presenter explicitly wrap the objects with decorators, but think about the flexibility of introducing factories/composite decorators that would allow the code in the presenter to stay static also. But those are patterns for another day!!

If anyone wants the source for this entry, please contact [me](mailto:bitwisejp@gmail.com). 








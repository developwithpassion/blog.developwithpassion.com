module Jekyll
  class VimeoTag < Liquid::Tag
    def initialize(tag_name,video_number,tokens)
      super
      @video_number = video_number
    end

    def render(context)
      return "<iframe src=\"http://player.vimeo.com/video/#{@video_number}\" width='400' height='255' frameborder='0' webKitAllowFullScreen mozillallowfullscreen allowFullScreen></iframe>"
    end
  end
end

Liquid::Template.register_tag('vimeo',Jekyll::VimeoTag)

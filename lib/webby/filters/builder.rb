# render XML via the XML Builder

if try_require('builder', 'builder')

  Loquacious.configuration_for(:webby) {
    desc <<-__
      A hash of options that will be passed to the Builder::XmlMarkup object
      when processing content through the 'builder' filter. See the Xml Builder
      rdoc documentation for the list of available options.
    __
    builder_options ({ :indent => 2 })
  }

  Webby::Filters.register :builder do |input, cursor|
    opts = (::Webby.site.builder_options || {}).symbolize_keys.merge((cursor.page.builder_options || {}).symbolize_keys)
    
    klass = opts.delete(:builder_class) ||
      Builder::XmlMarkup
    klass = Object.module_eval("::#{klass}") if klass.is_a?(String)

    b = cursor.renderer.get_binding
    
    eval(%Q{
      xml = ::#{klass.to_s}.new(#{opts.inspect})
      #{input}
      xml.target!
    }, b, '(builder)', -1)
  end
  
else
  Webby::Filters.register :builder do |input, cursor|
    raise Webby::Error, "'builder' must be installed to use the builder filter"
  end
end

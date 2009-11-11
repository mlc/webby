
require ::File.expand_path(
    ::File.join(::File.dirname(__FILE__), %w[.. .. spec_helper]))

# ---------------------------------------------------------------------------
describe 'Webby::Filters::Builder' do

  it 'should regsiter the builder filter handler' do
    Webby::Filters._handlers['builder'].should_not be_nil
  end

  if try_require('builder')

    it 'processes builder markup into XML' do
      input = %q{
        xml.instruct!
        xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
          xml.title "test"
          xml.comment! "This is not a complete atom document"
        end
      }
      cursor = mock("Cursor")
      page = mock("Page")
      cursor.stub!(:page).and_return(page)
      page.stub!(:builder_options).and_return(nil)
      renderer = mock("Renderer")
      cursor.stub!(:renderer).and_return(renderer)
      renderer.stub!(:get_binding).and_return(nil)
      output = Webby::Filters._handlers['builder'].call(input, cursor)

      output.should == %q{<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>test</title>
  <!-- This is not a complete atom document -->
</feed>
}
    end

  else

    it 'raises an error when builder is used but not installed' do
      input = "xml.instruct!"
      lambda {Webby::Filters._handlers['builder'].call(input)}.should raise_error(Webby::Error, "'builder' must be installed to use the builder filter")
    end

  end
end

# EOF

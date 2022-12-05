import com.k_int.kbplus.*


import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
// import com.vladsch.flexmark.profiles.pegdown.Extensions;
// import com.vladsch.flexmark.profiles.pegdown.PegdownOptionsAdapter;
// import com.vladsch.flexmark.util.options.DataHolder;

class PegdownTagLib {
  // static final DataHolder OPTIONS = PegdownOptionsAdapter.flexmarkOptions( Extensions.ALL);
  // static final Parser PARSER = Parser.builder(OPTIONS).build();
  // static final HtmlRenderer RENDERER = HtmlRenderer.builder(OPTIONS).build();

  final Parser PARSER = Parser.builder().build();
  final HtmlRenderer RENDERER = HtmlRenderer.builder().build();


  // use the PARSER to parse and RENDERER to render with pegdown compatibility

  def renderMarkdownAsHtml = { attrs, body ->
    String md_template 
    md_template = attrs.text ?: body()
    out << RENDERER.render(PARSER.parse(md_template));
  }

}


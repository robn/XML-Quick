# NAME

XML::Quick - Generate XML from hashes (and other data)

# SYNOPSIS

    use XML::Quick;

    $xml = xml($data);
    
    $xml = xml($data, { ... });

# DESCRIPTION

This module generates XML from Perl data (typically a hash). It tries hard to
produce something sane no matter what you pass it. It probably fails.

When you use this module, it will export the `xml` function into your
namespace. This function does everything.

## xml

The simplest thing you can do is call `xml` a basic string. It will be
XML-escaped for you:

    xml('v&lue');

    # produces: v&amp;lue
    

To create a simple tag, you'll need to pass a hash instead:

    xml({
          'tag' => 'value'
        });
    
    # produces: <tag>value</tag>

Of course you can have several tags in the same hash:

    xml({
          'tag' => 'value',
          'tag2' => 'value2'
        });
    
    # produces: <tag2>value2</tag2>
    #           <tag>value</tag>

Arrays will be turned into multiple tags with the same name:

    xml({
          'tag' => [
                     'one',
                     'two',
                     'three'
                   ]
        });
    
    # produces: <tag>one</tag>
    #           <tag>two</tag>
    #           <tag>three</tag>
    

Use nested hashes to produce nested tags:

    xml({
          'tag' => {
                     'subtag' => 'value'
                   }
        });
    
    # produces: <tag>
    #             <subtag>value</subtag>
    #           </tag>
    

A hash key with a value of `undef` or an empty hash or array will produce a
"bare" tag:

    xml({
          'tag' => undef
        });

    # produces: <tag/>

Adding attributes to tags is slightly more involved. To add attributes to a
tag, include its attributes in a hash stored in the `_attrs` key of the tag:

       xml({
             'tag' => {
                        '_attrs' => {
                                      'foo' => 'bar'
                                    }
                      }
           });

       # produces: <tag foo='bar'/>
    

Of course, you're probably going to want to include a value or other tags
inside this tag. For a value, use the `_cdata` key:

    xml({
          'tag' => {
                     '_attrs' => {
                                   'foo' => 'bar'
                                 },
                     '_cdata' => 'value'
                   }
        });

    # produces: <tag foo='bar'>value</tag>

For nested tags, just include them like normal:

    xml({
          'tag' => {
                     '_attrs' => {
                                   'foo' => 'bar'
                                 },
                     'subtag' => 'value'
                   }
        });
    
    # produces: <tag foo='bar'>
    #             <subtag>subvalue</subtag>
    #           </tag>

If you wanted to, you could include both values and nested tags, but you almost
certainly shouldn't. See ["BUGS AND LIMITATIONS"](#bugs-and-limitations) for more details.

There are also a number of processing options available, which can be specified
by passing a hash reference as a second argument to `xml()`:

- root

    Setting this will cause the returned XML to be wrapped in a single toplevel
    tag.

        xml({ tag => 'value' });
        # produces: <tag>value</tag>
        
        xml({ tag => 'value' }, { root => 'wrap' });
        # produces: <wrap><tag>value</tag></wrap>

- attrs

    Used in conjuction with the `root` option to add attributes to the root tag.

        xml({ tag => 'value' }, { root => 'wrap', attrs => { style => 'shiny' }});
        # produces: <wrap style='shiny'><tag>value</tag></wrap>

- cdata

    Used in conjunction with the `root` option to add character data to the root
    tag.

        xml({ tag => 'value' }, { root => 'wrap', cdata => 'just along for the ride' });
        # produces: <wrap>just along for the ride<tag>value</tag></wrap>

    You probably don't need to use this. If you just want to create a basic tag
    from nothing do this:

        xml({ tag => 'value' });

    Rather than this:

        xml('', { root => 'tag', cdata => 'value' });

    You almost certainly don't want to add character data to a root tag with nested
    tags inside. See ["BUGS AND LIMITATIONS"](#bugs-and-limitations) for more details.

- escape

    A flag, enabled by default. When enabled, character data values will be escaped
    with XML entities as appropriate. Disabling this is useful when you want to
    wrap an XML string with another tag.

        xml("<xml>foo</xml>", { root => 'wrap' })
        # produces: <wrap>&lt;xml&gt;foo&lt;/xml&gt;</wrap>

        xml("<xml>foo</xml>", { root => 'wrap', escape => 0 })
        # produces: <wrap><xml>foo</xml></wrap>

# BUGS AND LIMITATIONS

Because Perl hash keys get randomised, there's really no guarantee the
generated XML tags will be in the same order as they were when you put them in
the hash.  This generally won't be a problem as the vast majority of XML-based
datatypes don't care about order. I don't recommend you use this module to
create XML when order is important (eg XHTML, XSL, etc).

Things are even more hairy when including character data alongside tags via the
`cdata` or `_cdata` options. The `cdata` options only really exist to allow
attributes and values to be specified for a single tag. The rich support
necessary to support multiple character data sections interspersed alongside
tags is entirely outside the scope of what the module is designed for.

There are probably bugs. This kind of thing is an inexact science. Feedback
welcome.

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/robn/XML-Quick/issues](https://github.com/robn/XML-Quick/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/robn/XML-Quick](https://github.com/robn/XML-Quick)

    git clone https://github.com/robn/XML-Quick.git

# AUTHOR

Robert Norris <rob@eatenbyagrue.org>

# CONTRIBUTORS

- YAMASHINA Hio fixed a bug where `xml` would modify the caller's data
- Dawid Joubert suggested escaping non-ASCII characters and provided a patch
(though I did it a little bit differently to how he suggested)
- Peter Eichman fixed a bug where single quotes in attribute values were not
being escaped.

# COPYRIGHT AND LICENSE

This software is copyright (c) 2005-2006 Monash University, (c) 2008-2015 by Robert Norris.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

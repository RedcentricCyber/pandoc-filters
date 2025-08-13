# Redcentric's Pandoc Filters

This repository represents a number of [Pandoc
Filters](https://pandoc.org/lua-filters.html) that can be used to generate
documentation. These filters allow for files written in Markdown, too be
converted into \LaTeX using Pandoc, which can  then be used to produce a PDF.

## Columns

The columns filter adds the ability to have multi-column sections. It requires
the [multicols](https://ctan.org/pkg/multicol) package. Use:

```
:::col-n
CONTENT
:::
```

Where n is the number of columns you wish. For example:

```
:::col-3
this will

be in

three columns
:::
```


![](./images/2025-06-13-10-25-21.png)


Normal markdown will work as the contents.

## Indent

The indent filter does as it says on the tin. It indents the contents. It can be
nested if you want. It requires the
[changepage](https://ctan.org/pkg/changepage) package.

```
This is a normal paragraph

:::indent
This is indented once

:::indent
This is indented twice
:::

:::
```

![](./images/2025-06-13-10-40-46.png)


## Colour Code

This filter is used for highlighting sections of code. Note that this IS NOT
syntax highlighting, but for drawing attention to sections of code.

It requires the [soul](https://ctan.org/pkg/soul) package for highlighting.

It requires pandoc to be called with the [listings](https://pandoc.org/MANUAL.html#option--listings[) option.

It also requires listings to be set with escapeinside specified in lstset. The
below should be in the latex template used by pandoc.

```
\lstset{
	escapeinside={\#(}{\#)},
	breaklines=true,
}
```

It expects a number of latex colours to be set using the
[xcolor](https://ctan.org/pkg/xcolor) package:

```
\definecolor{RCcritical}{HTML}{F50D25}
\definecolor{RChigh}{HTML}{AC0619}
\definecolor{RCmedium}{HTML}{FDBF2D}
\definecolor{RClow}{HTML}{94CE58}
\definecolor{RCinfo}{HTML}{2BA2E6}
```

And it expects the following latex macros to be defined:

```
\definecolor{RCblue}{HTML}{09347a}
\newcommand{\codeSnip}{\textit{\textbf{\textcolor{RCblue}{--SNIP--}}}}
\newcommand{\codeRedacted}{\textit{\textbf{\textcolor{RCblue}{--REDACTED--}}}}
```

```
# Example Heading 1

## Example Heading 2

{CODECOMMENT: Headings}
Markdown supports up to h6
{/CODECOMMENT}

![{YELLOW}A Caption{/YELLOW}](path/to/image.jpg)
```

![](./images/2025-06-13-11-17-42.png)

This shows how code can be highlighted. In this example, `{YELLOW}` is used. It
is possible to use any of the following:

* CRITICAL
* HIGH
* MEDIUM
* LOW
* INFORMATIONAL
* YELLOW
* RED
* ORANGE
* BLUE
* GREEN

The `{REDACTED}` or `{SNIP}` shortcodes insert the `\codeSnip` or
`\codeRedacted` latex macro.

The multi-line `{CODECOMMENT}` shortcode adds a centred "notes" box to the code
block which can be useful for annotating code.

## YAML Tables

For the most part, we really like markdown. However, we don't like markdown
tables. Any of them. So, what did we do? Make yet another way of doing them.


![](https://imgs.xkcd.com/comics/standards.png)

In the most basic form, they look like this:

````

```table
- Column 1: row1col1
  Column 2: row1col2
  Column 3: row1col3
- Column 1: row2col1
  Column 3: row2col3
  Column 2: row2col2
```
````

![](./images/2025-06-13-14-15-26.png)

However, they are a fair few more options, so documentation for that is
[here](docs/yaml-tables.md).


## CSV Tables

It is also possible to include a CSV or TSV file as a table. You do this using
the normal markdown image syntax:

For instance,

```markdown
![Caption](path/to/file.csv)
```

This will include a csv file as a table. The first row will be used as the table
header. A caption is optional.

It is noteworthy that the same options (except transpose) that are available for
yaml tables, are available for csv tables. For example:

```markdown
![Caption](path/to/file.csv){align=XYZ}
```

## Only Headers

This one is a bit different. You probably don't want this for the main
generation of a document, but it is a useful helper at times to pull out headers
to get an idea of the outline of a document.


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




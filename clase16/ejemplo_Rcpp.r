---
title: "Untitled"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

$$\[ f(n) = \begin{cases} n & \text{si $n<2$} \\ f(n-1) + f(n - 2) & \text{si $n\geq2$} \end{cases} \]$$

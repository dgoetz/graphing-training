# Training

This training is designed as a two days hands-on training introducing Graphite and Grafana.

In the training you will get basic knowledge of Graphite and Grafana.

Targeted audience are experienced Linux administrators.

In addition to the sources you can find the rendered material on 
[netways.github.io](https://netways.github.io/graphing-training)

* [Presentation](https://netways.github.io/graphing-training)
* [Handouts](https://github.com/NETWAYS/graphing-training/releases/download/v1.0.0/graphing-training-handouts.pdf)

## Provide your training

To run the presentation you will need [showoff 0.9.11.1](https://rubygems.org/gems/showoff/versions/0.9.11.1).
After installing it simply run `showoff serve` to get presenter mode with additional notes
and display window to present to your students.

For creating the rendered documents on your own run `showoff static print` (handouts) followed by 
`wkhtmltopdf -s A5 --print-media-type --footer-left [page] --footer-right 'Graphite + Grafana Training' static/index.html graphing-training-handouts.pdf`

For some notes on setting up the training enviroment have a look at 'Setup.md'.

# Contribution

Patches to fix mistakes or add optional content are always appreciated. If you want to see
changes on the default content of the training we are open for suggestions but keep in mind
that the training is intended for a three day hands-on training.

The rendered content will be updated at least if we do a newer version of the material which
will also be tagged on git.

Material is licensed under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-nc-sa/4.0/).

# Intro

Here are some notes in consideration of [this message to ffmpeg-devel](http://ffmpeg.org/pipermail/ffmpeg-devel/2017-November/220530.html) regarding the [AS-07 specification](http://www.digitizationguidelines.gov/guidelines/MXF_app_spec.html) and the gaps between that and FFmpeg's existing mxf muxer.

# compare_mxf.sh

This is a shell script to download the AS-07 sample, produce a similar file from ffmpeg, and produce another file from remuxing the AS-07 sample. The results are then represented in MediaTrace documents, and diffed to patches to reveal the differences between the AS-07 sample and FFmpeg's current output. See compare_mxf.sh for details.

# results

See [remuxed_v_as07.patch](./remuxed_v_as07.patch) and [newsample_v_as07.patch](newsample_v_as07.patch).

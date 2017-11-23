#!/bin/bash

# requires ffmpeg, wget, unzip, mediaconch, xml (xmlstarley), diff
# this script downloads an AS-07 sample, remuxes it with ffmpeg, and creates a new sample as similar to the AS-07 sample via ffmpeg with libavfilter inputs. The script then uses mediaconch to make a document that annotates the structure of the files and compares them. The resulting patches can reveal how many changes would be required to mxfenc.c to create something similar to the AS-07 sample. Note that many of the differences highlighted in the patches are unique identifiers and other data that is not relevant to whether the file is or isn't valid AS-07.

wget "http://www.digitizationguidelines.gov/guidelines/MXF_sampleFiles/as07_sample2-gf-jpeg2000-3.1.mxf.zip"
unzip as07_sample2-gf-jpeg2000-3.1.mxf.zip

# remuxed the AS-07 sample with FFmpeg's mxf muxer
ffmpeg -i as07_sample2-gf-jpeg2000-3.1.mxf -c copy -map 0 remuxed.mxf
ffmpeg -f lavfi -i testsrc=s=720x243:r=30000/1001 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -f lavfi -i sine=r=48000 -vf setfield=bff,setsar=9:20,format=yuv422p10le -map 0 -map 1 -map 2 -map 3 -map 4 -map 5 -map 6 -map 7 -map 8 -metadata:s "timecode=01:00:00;00" -t 00:00:20.02 -c:v jpeg2000 -c:a pcm_s24le ffmpeg_sample.mxf

# document structure of both the sample and the remuxed copy
mediaconch -mt as07_sample2-gf-jpeg2000-3.1.mxf > as07.xml
mediaconch -mt remuxed.mxf                      > remuxed.xml
mediaconch -mt ffmpeg_sample.mxf                > ffmpeg_sample.xml

# remove offset and size attributes to make the xml more diffable
xml edit -N "mt=https://mediaarea.net/mediatrace" -d //@offset -d //@size as07.xml            > as07.xml
xml edit -N "mt=https://mediaarea.net/mediatrace" -d //@offset -d //@size remuxed.xml         > remuxed_no_offset_no_size.xml
xml edit -N "mt=https://mediaarea.net/mediatrace" -d //@offset -d //@size ffmpeg_sample.xml   > ffmpeg_sample_no_offset_no_size.xml

# create a patch to show the structural difference between the AS07 sample and the remuxed sample
diff -Naur remuxed_no_offset_no_size.xml as07_no_offset_no_size.xml         > remuxed_v_as07.patch
diff -Naur ffmpeg_sample_no_offset_no_size.xml as07_no_offset_no_size.xml   > newsample_v_as07.patch
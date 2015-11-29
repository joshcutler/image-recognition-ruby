#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-

# A Demo Ruby/OpenCV Implementation of SURF
# See https://code.ros.org/trac/opencv/browser/tags/2.3.1/opencv/samples/c/find_obj.cpp
require 'opencv'
include OpenCV

cascade_file = "#{Dir.pwd}/training/twins-classifier2/cascade.xml"
detector = CvHaarClassifierCascade.load(cascade_file)

examples = ['test.jpg', 'shivan dragon.hq.jpg']

examples.each do |file_name|
  image = CvMat.load(file_name)
  detector.detect_objects(image).each do |region|
    color = CvColor::Blue
    image.rectangle! region.top_left, region.bottom_right, :color => color
  end

  image.save_image("processed_#{file_name}")
  window = GUI::Window.new('Twins Detector')
  window.show(image)
  GUI::wait_key
end
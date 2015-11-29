# Relies on rtesseract, rmagick
require 'rtesseract'
require 'rmagick'

image_name = 'shivan dragon.hq.jpg'

# Naive approach
source = RTesseract.new(image_name)
puts source.to_s

# Transform to grayscale approach
transformed = RTesseract.read(image_name) do |img|
  img = img.white_threshold(25000)
  img = img.quantize(256, Magick::GRAYColorspace)
end
transformed.to_s

# Body text
source = Magick::Image.read(image_name).first
c = source.crop(50, 425, 390, 180)
c.write "jpeg:ocr-body-cropped.jpg"
RTesseract.new('ocr-body-cropped.jpg', debug: true).to_s

# What about the title?
source = Magick::Image.read(image_name).first
c = source.crop(10, 10, 200, 40)
c.write "jpeg:ocr-head-cropped.jpg"
t = c.white_threshold 29000
t.write "jpeg:ocr-head-white.jpg"
q = t.quantize 256, Magick::GRAYColorspace
q.write "jpeg:ocr-head-quantized.jpg"
n = q.negate
n.write "jpeg:ocr-head-negated.jpg"
w = n.white_threshold 28000
w.write "jpeg:ocr-head-white2.jpg"
RTesseract.new('ocr-head-white2.jpg', debug: true).to_s

# Or the type?
source = Magick::Image.read(image_name).first
c = source.crop(30, 375, 200, 30)
c.write "jpeg:ocr-type-cropped.jpg"
t = c.white_threshold 29000
t.write "jpeg:ocr-type-white.jpg"
q = t.quantize 256, Magick::GRAYColorspace
q.write "jpeg:ocr-type-quantized.jpg"
n = q.negate
n.write "jpeg:ocr-type-negated.jpg"
w = n.white_threshold 28000
w.write "jpeg:ocr-type-white2.jpg"
RTesseract.new('ocr-type-white2.jpg', debug: true).to_s

# What if we doin't know anything about the card before hand?
source = RTesseract.new('teddy3.jpg')
puts source.to_s

# Time for some CS magic
original = Magick::Image.read('test.jpg').first
height = original.rows
width = original.columns
cropped_height = (height / 3)

# Crop the sections
top = original.crop(0, 0, width, cropped_height)
top.write("jpeg:ocr-general-top.jpg")
bottom = original.crop(0, height.to_f / 3 * 2, width, cropped_height)
bottom.write("jpeg:ocr-general-bottom.jpg")

out_path_top_w = "#{Dir.pwd}/detect_text_top_w.jpg"
out_path_top_b = "#{Dir.pwd}/detect_text_top_b.jpg"

out_path_bottom_w = "#{Dir.pwd}/detect_text_bottom_w.jpg"
out_path_bottom_b = "#{Dir.pwd}/detect_text_bottom_b.jpg"

# Run SWT
%x(/Users/joshcutler/Code/DetectText/DetectText '#{Dir.pwd}/ocr-general-top.jpg' '#{out_path_top_w}' 1)
rtess = RTesseract.new(out_path_top_w)
puts "First pass top: #{rtess.to_s}"
%x(/Users/joshcutler/Code/DetectText/DetectText '#{Dir.pwd}/ocr-general-top.jpg' '#{out_path_top_b}' 0)
rtess.source = out_path_top_b
puts "Second pass top: #{rtess.to_s}"

%x(/Users/joshcutler/Code/DetectText/DetectText '#{Dir.pwd}/ocr-general-bottom.jpg' '#{out_path_bottom_w}' 1)
rtess = RTesseract.new(out_path_bottom_w)
puts "First pass bottom: #{rtess.to_s}"
%x(/Users/joshcutler/Code/DetectText/DetectText '#{Dir.pwd}/ocr-general-bottom.jpg' '#{out_path_bottom_b}' 0)
rtess.source = out_path_bottom_b
puts "Second pass bottom: #{rtess.to_s}"
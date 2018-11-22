rm -rf tmp/Testing_Data
rm -rf tmp/Training_Data
mkdir -p tmp/Testing_Data
mkdir -p tmp/Training_Data
googleimagesdownload --print_urls -kf scripts_image_google/classes.txt -l 100 -o tmp/Training_Data

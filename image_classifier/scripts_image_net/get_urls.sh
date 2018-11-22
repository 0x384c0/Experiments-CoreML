function write_to_fifo {
	cat "imagenet_ids.txt" | grep " - " > tmp_fifo
}
function read_from_fifo {
	while read line; do
		image_id=$(echo $line | sed "s| - .*$||g")
		name=$(echo $line | sed "s|^.* - ||g")
		echo "name: $name, image_id: $image_id"
		mkdir -p "tmp/$name"
		wget -c -O "tmp/$name/batch.txt" "http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=$image_id"
	done < tmp_fifo
}

mkfifo tmp_fifo
write_to_fifo &
read_from_fifo
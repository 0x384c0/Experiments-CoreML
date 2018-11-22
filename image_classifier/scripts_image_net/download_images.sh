cd tmp
for D in *; do
    if [ -d "${D}" ]; then
    	cat "$D/batch.txt" | tr -d '\r' | xargs -n 1 -P 10 wget -c -T 2 --tries 1 -P "$D/"
	# wget -i "$D/batch.txt"  -c -T 2 --tries 1 -P "$D/"
	# cat "$D/batch.txt" | tr -d '\r' | xargs -n 1 -P 10 -I {} sh -c "echo {};  wget -c -T 2 --tries 1 -P "$D/" \"{}\""
    fi
done
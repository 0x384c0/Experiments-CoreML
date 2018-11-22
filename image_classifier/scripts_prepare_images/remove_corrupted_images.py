import glob, re, os, shutil
from PIL import Image


def move_to_trash(filename):
	try:
		shutil.move(filename, filename.replace("tmp/",trashFolder))
	except:
		os.remove(filename)

def cleanup(path):
	trashFolder =  "tmp/trash/"
	if not os.path.exists(trashFolder):
		os.mkdir(trashFolder)

	for filename in glob.iglob(path + '**', recursive=True):
		pattern = ".*\.(?:png|jpg|jpeg|gif|png|svg)$"
		result = re.match(pattern, filename, re.IGNORECASE)
		if result:
			try:
				img = Image.open(filename) # open the image file
				img.verify() # verify that it is, in fact an image
				img = Image.open(filename)
				img.load()
			except (IOError, SyntaxError) as e:
				print("Deleting Bad image file: ", filename) # print out the names of corrupt files
				move_to_trash(filename)
		else:
			if os.path.isfile(filename):
				print("Deleting Not image file: " + filename)
				move_to_trash(filename)




cleanup("tmp/Testing_Data/")
cleanup("tmp/Training_Data/")
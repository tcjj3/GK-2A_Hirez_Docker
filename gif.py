import imageio
import glob
import re


def create_gif(image_list, gif_name):
    frames = []
    
    print("Creating gif file...")
    
    for image_name in image_list:
        print("File   - " + image_name)
        frames.append(imageio.imread(image_name))
        
    print("")
    print("Saving  - " + gif_name)
    
    # Save them as frames into a gif
    kargs = { 'duration': 0.1, 'fps': 1 }
    imageio.mimsave(gif_name, frames, 'GIF', **kargs)
    
    print("Saved  - " + gif_name)
    print("")
    print("Done.")
    
    return




def find_all_jpg():
    jpg_filenames = glob.glob("./*.jpg")
    jpg_filenames.sort()
    
    print("Found " + str(len(jpg_filenames)) + " file(s):")
    for jpg_file in jpg_filenames:
        if not jpg_file.find("_pressed") > -1:
            print("  - " + jpg_file)
    print("")
    
    buf=[]
    for jpg_file in jpg_filenames:
        if not jpg_file.find("_pressed") > -1:
            buf.append(jpg_file)
    
    return buf





if __name__ == '__main__':
    buff = find_all_jpg()
    create_gif(buff, 'created_gif.gif')






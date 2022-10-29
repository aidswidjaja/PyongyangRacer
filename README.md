**Update from 29 October 2022**

So, this repo somehow got featured in a YouTube video :D – https://youtu.be/7sO5Po2PNdw?t=573

I was pretty surprised that the person in the video extracted the assets via the cache in the SeaMonkey profile in this repo, using that to play the game, but if you're looking for a quick, easy, non-roundabout way of getting playing PyongyangRacer for yourself, I'd recommend [BlueMaxima's Flashpoint](https://bluemaxima.org/flashpoint/). This repo was never meant for public usage - and support isn't being provided for it. Thanks for your understanding!

***

# Pyongyang Racer
> "Don't stare at me, I'm on duty."

[Pyongyang Racer](https://en.wikipedia.org/wiki/Pyongyang_Racer) (publicly available at http://www.pyongyangracer.co/) is North Korea's only publicly-available video game, produced by students at Kim Chaek University of Technology. 

![PyongyangRacer](https://user-images.githubusercontent.com/36395320/117536406-2c24c400-b03e-11eb-8c3b-842d21eba56f.jpg)

## Getting started

- Download the Pyongyang Racer application from the [Releases](https://github.com/aidswidjaja/PyongyangRacer/releases) page.
- Open the application and play :)

Note: you must be connected to the Internet to play...

## Developer notes

Unfortunately, it is a Flash game and we all know what happened to that... The only copy I could find is this one on [swfchan](http://swfchan.com/29/143906/?Pyongyang+Racer+-+Koryo+Tours.swf) and [Flashpoint](https://bluemaxima.org/flashpoint/) which has incorrect metadata, has a corrupt screenshot, and was last seen online in 2014. And the SWF doesn't even work (see below for why).

The `.swf` file is served publicly from the website at `http://www.pyongyangracer.co/PYracer.swf`, however Microsoft IIS/8.5 doesn't like serving `.swf` files and throws a 403 Forbidden error. There was no easy way to get hold of the `.swf` file. This means that should the website go down, all traces of Pyongyang Racer could be lost, or buried deep in the web without any easy way of getting to it. Which is why I have taken it upon myself to serve my comrades and preserve this beautiful game! (Also my Modern History class has been meming over it so yea that too).

To work around this, I used the SeaMonkey plugin available from Flashpoint Infinity (but also stored in `Library/Internet\ Plug-ins` on macOS) on my own installation of SeaMonkey (removing the Flashpoint Seamonkey Profile that prevented external HTTP connections). I went to the site, where the game loaded successfully. To extract the file, I used Seamonkey/Firefox's Developer Tools to obtain a cURL with all the headers I needed, spoofing the network packet and bypassing the 403 Forbidden error:

```bash
curl 'http://pyongyangracer.co/PYracer.swf' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11.3; rv:88.0) Gecko/20100101 Firefox/88.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://pyongyangracer.co/index.html' -H 'Cookie: __utma=212429845.1318411643.1620428083.1620445834.1620453914.3; __utmz=212429845.1620428083.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmb=212429845.3.10.1620453914; __utmc=212429845; __utmt=1' -H 'DNT: 1' -H 'Connection: keep-alive' --output PYracer.swf
```

Note: I changed my User Agent string from Seamonkey/ to Firefox for better compatibility on other websites. My actual User Agent string was `Mozilla/5.0 (Macintosh; Intel Mac OS X 10.0; rv:60.0) Gecko/20100101 Firefox/60.0 SeaMonkey/2.53.4` but I doubt this would affect the 200 OK response from the curl command.

To ensure preservation, I'm running my own instance of the [Pyongyang Racer website](https://pyongyangracer.co) at [pyracer.adrian.id.au](https://pyracer.adrian.id.au). However, it still needs to be accessed from a special SeaMonkey bundle that I have included in `dist`. The SWF is hosted on the site but does not have access to external assets it's trying to use for some reason.

Using that SeaMonkey version with the Flash plugin from Flashpoint Infinity already installed, means that it is easily portable and users can play Pyongyang Racer with minimal setup.

Unfortunately, the SWF file is reliant on other resources from the web server - including soundtracks, binaries, and symbol files which are not included (e.g http://pyongyangracer.co/PreGame.mp3). The SWF on swfchan, Flashpoint, and virtually all SWF versions are reliant on external assets. This is most likely due to SWFObject intefering with the resulting SWF.

For now at least, the original web server is still online, and the SWF file is on its own sitting there - only succeding at the splash screen. It may be possible to get all resources for it, but I don't have the time to work on that. For now packaging a version of SeaMonkey to play Pyongyang Racer is good enough for me.

Technically speaking, the web browser can play any Flash game, but I would highly recommend to use Flashpoint instead due to the numerous security issues this presents. This is effectively a quick and dirty solution that I made up in 2 days.

### Decompliation

I used [JPEXS Decompiler](https://github.com/jindrapetrik/jpexs-decompiler) to extract model meshes and other assets used in the game, as well as The Unarchiver for purely image and sound assets.

### Useful information

```html
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="FlashID" title="Pyongyang Racer" style="visibility: visible;" width="760" height="500">
    <param name="movie" value="PYracer.swf">
    <param name="quality" value="high">
    <param name="wmode" value="opaque">
    <param name="swfversion" value="6.0.65.0">
    <!-- This param tag prompts users with Flash Player 6.0 r65 and higher to download the latest version of Flash Player. Delete it if you don’t want users to see the prompt. -->
    <param name="expressinstall" value="Scripts/expressInstall.swf">
    <!-- Next object tag is for non-IE browsers. So hide it from IE using IECC. -->
    <!--[if !IE]>-->
    <object type="application/x-shockwave-flash" data="PYracer.swf" width="760" height="500">
</object>
```

#  rgb-hdmi-aoc-amdgpu

A crappy script to set custom EDID without YCbCr support to force RGB output on HDMI when using Radeon GPUs.
Thanks to: 
https://www.wezm.net/v2/posts/2020/linux-amdgpu-pixel-format/ <br/> https://gist.github.com/RLovelett/171c374be1ad4f14eb22fe4e271b7eeb

#### Warning
I wrote this for personal use, oriented to Arch Linux + GRUB with a patched EDID from my AOC 22" monitor that may not be suitable for your use case. Please refer to the links above if you're looking for the custom EDID creation steps.

## Why?
I switched to a laptop with the Ryzen 5 4500U "APU", which contains a Radeon integrated GPU. I use a cheap external HDMI monitor that doesn't allow to choose a pixel input format, but its EDID reports being compatible with YCbCr, since [amdgpu hardcodes this pixel format when is detected as supported](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c?id=dc4060a5dc2557e6b5aa813bf5b73677299d62d2#n2767), the result is a terrible dark and oversaturated image.

There is an easy fix for Windows users, via Radeon Software:
![Pixel format setting on Radeon Software for Windows](https://cdn.discordapp.com/attachments/751625825333280789/916625219433680937/amdkk.png)

However, for Linux users who don't want to mess with proprietary drivers like if they've got a GPU from some green-eye-and-square company (honestly, I didn't bother thinking about AMDGPU-PRO), apparently, there are two ways of fixing this issue:

- Patching amdgpu and recompiling the kernel.
- Tricking the GPU into thinking YCbCr is not supported to force RGB using a custom EDID.

I decided to take the second approach because the kernel is frequently updated in Arch Linux and I don't feel Gentoo-user enough to recompile it patched on every update.

## How to use
Simply clone the repo and run `rgb.sh` as root. <br/>
`# git clone https://github.com/ncr6/rgb-hdmi-aoc-amdgpu` <br/>
`# cd rgb-hdmi-aoc-amdgpu` <br/>
`# ./rgb.sh` <br/>

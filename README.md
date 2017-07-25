# What is this repository for?

This repository is to provide docker images for clean Linux desktop and
either to ensure that mono and .NET Core repositories build without problem
or to prove they don't build.

I am tired of hearing "it works for me" kind of replies when I get build
errors. On the other hand my environment could be messed by some manual
workarounds and thus I want to know the clean build state.

However no one in the .NET Core team or Mono team care about their sanity
state when both are mixed together. They are building stuff only on the
servers. Some individuals at Xamarin build them but their environment is
not known to be clean either. This repository is to provide neutral sight
to everyone.

Right now there is only one Dockerfile that indicates Ubuntu 16.04 (which
does not already meet my need because I'm based on Ubuntu 17.04 where
msbuild fails to build due to lame dotnet/cli bug) but it will become
better.

Lastly, it is based on xamarin-android/Dockerfile, so there are extraneous
bits so far (do not worry, xamarin-android will become a target too).


# List of the target modules

- mono
- gtk-sharp
- msbuild
- fsharp
- monodevelop


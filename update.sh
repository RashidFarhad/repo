#!/bin/sh

for i in ./debs/*.deb
do
   debInfo=`dpkg -f $i`
   dep=`echo "$debInfo" | grep "Depiction: " | cut -c 12- | tr -d "\n\r"`
   home=`echo "$debInfo" | grep "Homepage: " | cut -c 11- | tr -d "\n\r"`
   pkg=`echo "$debInfo" | grep "Package: " | cut -c 10- | tr -d "\n\r"`
   maintainer=`echo "$debInfo" | grep "Maintainer: " | cut -c 13- | tr -d "\n\r"`
   sponsor=`echo "$debInfo" | grep "Sponsor: " | cut -c 10- | tr -d "\n\r"`
   #Maintainer: lutoan
   #Author: lutoan
   #Sponsor: lutoan
   
   dpkg-deb -R $i ./debs/tmp
   
       buildDEBIAN=0
   if [[ -z $dep ]]; then
       echo "Depiction: ${pkg}" >> ./debs/tmp/DEBIAN/control
       buildDEBIAN=1
   fi
   if [[ -z $home ]]; then
        echo "Homepage: https://lutoan.github.io/repo" >> ./debs/tmp/DEBIAN/control
       buildDEBIAN=1
   fi
   if [[ -z $maintainer ]]; then
        echo "Maintainer: lutoan" >> ./debs/tmp/DEBIAN/control
       buildDEBIAN=1
   fi
   if [[ -z $sponsor ]]; then
        echo "Sponsor: lutoan" >> ./debs/tmp/DEBIAN/control
       buildDEBIAN=1
   fi
   #binary 0 or 1
   echo "\"$pkg\" = "
   read changePkg
       #read -p "Do you change pkg \"$pkg\"? >> " changePkg

   if [[ ! -z "$changePkg" ]]; then
      sed -i "s/Package: $pkg/Package: $changePkg/" "$control"
       pkg="$changePkg"
   fi

   if [[ $buildDEBIAN == 1 ]]; then
       bsname=$(basename "$i")
       dpkg -bR ./debs/tmp "./debs/$bsname"
       debInfo=`dpkg -f $i`
       echo "$i" >> changelog.log
   fi
#no sign =====================
#add Depiction done ==========

done

apt-ftparchive packages ./debs > ./Packages;
#sed -i -e '/^SHA/d' ./Packages;
bzip2 -c9k ./Packages > ./Packages.bz2;
echo "------------------"
echo "Building Release...."
printf "Origin: Lu Toan Repo\nLabel: Lu Toan\nSuite: stable\nVersion: 1.0\nCodename: ios\nArchitecture: iphoneos-arm\nComponents: main\nDescription: Chia se tweak hay\nMD5Sum:\n "$(cat ./Packages | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages --printf="%s")" Packages\n "$(cat ./Packages.bz2 | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages.bz2 --printf="%s")" Packages.bz2\n" >Release;

echo "------------------"
echo "Done!"
exit 0;
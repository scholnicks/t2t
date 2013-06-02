#!/bin/bash

echo -n "Empty line w/o squeeze - "

cat > /tmp/emptyline_data << __DATA__
Archer:6:1
::
Scholnick:7:5
__DATA__

cat > /tmp/emptyline_expected.html << __DATA__
<table border="0" summary="t2t table">
<tr> <td>Archer</td> <td>6</td>  <td>1</td> </tr>
<tr> <td>&nbsp;</td> <td>&nbsp;</td> <td>&nbsp;</td> </tr>
<tr> <td>Scholnick</td>   <td>7</td>  <td>5</td> </tr>
</table>
__DATA__

cat > /tmp/emptyline.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>false</header>
        <oneTable>true</oneTable>
        <nbsp>false</nbsp>
       	<emptyline>true</emptyline>
        <tablesOnly>true</tablesOnly>
    </general>
    <table>
        <border>0</border>
    </table>
</t2t>
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --tables --init /tmp/emptyline.rc < /tmp/emptyline_data > /tmp/emptyline_actual.html

results=`diff -b -B -i -w /tmp/emptyline_expected.html /tmp/emptyline_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/emptyline_expected.html /tmp/emptyline_actual.html /tmp/emptyline.rc /tmp/emptyline_data

exit $returnCode

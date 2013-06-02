#!/bin/bash

echo -n "Squeezing With NBSP - "

cat > /tmp/squeeze_data << __DATA__
Archer:6:1
::
Scholnick:7:5
__DATA__

cat > /tmp/squeeze_expected.html << __DATA__
<table border="0" summary="t2t table">
<tr> <td>Archer</td> <td>6</td>  <td>1</td> </tr>
<tr> <td>Scholnick</td>   <td>7</td>  <td>5</td> </tr>
</table>
__DATA__

cat > /tmp/squeeze.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>false</header>
        <oneTable>true</oneTable>
        <nbsp>true</nbsp>
       	<squeeze>true</squeeze>
        <tablesOnly>true</tablesOnly>
    </general>
    <table>
        <border>0</border>
    </table>
</t2t>
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --init /tmp/squeeze.rc < /tmp/squeeze_data > /tmp/squeeze_actual.html

results=`diff -b -B -i -w /tmp/squeeze_expected.html /tmp/squeeze_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/squeeze_expected.html /tmp/squeeze_actual.html /tmp/squeeze.rc /tmp/squeeze_data

exit $returnCode

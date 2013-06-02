#!/bin/bash

echo -n "Null Cell - "

cat > /tmp/three_data << __DATA__
Name:Rank:Won:Lost
Archer:6::1
Scholnick:7:5:4
__DATA__

cat > /tmp/three_expected.html << __DATA__
<table border="0" summary="t2t table">
<tr> <td>Name</td>   <td>Rank</td>   <td>Won</td>  <td>Lost</td>   </tr>
<tr> <td>Archer</td> <td>6</td>  <td>&nbsp;</td>  <td>1</td> </tr>
<tr> <td>Scholnick</td>   <td>7</td>  <td>5</td>  <td>4</td>   </tr>
</table>
__DATA__

cat > /tmp/three.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>false</header>
        <oneTable>false</oneTable>
        <nbsp>true</nbsp>
       	<squeeze>0</squeeze>
        <tablesOnly>true</tablesOnly>
    </general>
    <table>
        <border>0</border>
    </table>
</t2t>
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --init /tmp/three.rc < /tmp/three_data > /tmp/three_actual.html

results=`diff -b -B -i -w /tmp/three_expected.html /tmp/three_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/three_expected.html /tmp/three_actual.html /tmp/three.rc /tmp/three_data

exit $returnCode

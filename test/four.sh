#!/bin/bash

echo -n "No Squeeze - "

cat > /tmp/four_data << __DATA__
Name:Rank:Won:Lost
Archer:6:5:1
Scholnick:7:5:4
__DATA__

cat > /tmp/four_expected.html << __DATA__
<table border="0" summary="t2t table">
<tr> <td>Name</td>    <td>Won</td>  <td>Lost</td>   </tr>
<tr> <td>Archer</td>  <td>5</td>  <td>1</td> </tr>
<tr> <td>Scholnick</td> <td>5</td>  <td>4</td>   </tr>
</table>
__DATA__

cat > /tmp/four.rc << __DATA__
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

/Users/scholnick/perl/t2t/t2t.pl --init /tmp/four.rc --skip 2 < /tmp/four_data > /tmp/four_actual.html

results=`diff -b -B -i -w /tmp/four_expected.html /tmp/four_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/four_expected.html /tmp/four_actual.html /tmp/four.rc /tmp/four_data

exit $returnCode

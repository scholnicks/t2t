#!/bin/bash

echo -n "No Border - "

cat > /tmp/two_expected.html << __DATA__
<table border="0" summary="t2t table">
   <tr>      <td>Name</td>      <td>Rank</td>      <td>M Won</td>      <td>M Lost</td>      <td>M %</td>      <td>G Won</td>      <td>G Lost</td>      <td>G %</td>   </tr>
   <tr>      <td>Ahmadi,Ali</td>      <td>6.08</td>      <td>3</td>      <td>1</td>      <td>75.00</td>      <td>11</td>      <td>14</td>      <td>44.00</td>   </tr>
   <tr>      <td>Scholnick,Steve</td> <td>5.00</td>      <td>5</td>      <td>0</td>      <td>100.00</td>      <td>10</td>      <td>2</td>      <td>80.00</td>   </tr>
</table>
__DATA__

cat > /tmp/two.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>false</header>
        <oneTable>false</oneTable>
        <nbsp>0</nbsp>
       	<squeeze>1</squeeze>
         <tablesOnly>true</tablesOnly>
    </general>
    <table>
        <border>0</border>
    </table>
</t2t>
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --init /tmp/two.rc < /Users/scholnick/perl/t2t/test/ranks > /tmp/two_actual.html

results=`diff -b -B -i -w /tmp/two_expected.html /tmp/two_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/two_expected.html /tmp/two_actual.html /tmp/two.rc

exit $returnCode

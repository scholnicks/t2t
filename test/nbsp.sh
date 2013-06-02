#!/bin/bash

echo -n "NBSP - "

cat > /tmp/nbsp_expected.html << __DATA__
<table border="1" summary="t2t table">
   <thead><tr>      <th>Name</th>      <th>Rank</th>      <th>M Won</th>      <th>M Lost</th>      <th>M %</th>      <th>G Won</th>      <th>G Lost</th>      <th>G %</th>   </tr></thead>
   <tr>      <td>Ahmadi,Ali</td>      <td>6.08</td>      <td>3</td>      <td>1</td>      <td>75.00</td>      <td>11</td>      <td>14</td>      <td>44.00</td>   </tr>
   <tr>      <td>Scholnick,Steve</td> <td>5.00</td>      <td>5</td>      <td>0</td>      <td>100.00</td>      <td>10</td>      <td>2</td>      <td>80.00</td>   </tr>
</table>
__DATA__

cat > /tmp/nbsp.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>yes</header>
        <oneTable>false</oneTable>
        <nbsp>true</nbsp>
       	<squeeze>1</squeeze>
         <tablesOnly>true</tablesOnly>
    </general>
    <table>
        <border>1</border>
    </table>
</t2t>
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --tables --init /tmp/nbsp.rc < /Users/scholnick/perl/t2t/test/ranks > /tmp/nbsp_actual.html

results=`diff -b -B -i -w /tmp/nbsp_expected.html /tmp/nbsp_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/nbsp_expected.html /tmp/nbsp_actual.html /tmp/nbsp.rc

exit $returnCode

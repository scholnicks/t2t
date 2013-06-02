#!/bin/bash

echo -n "Limit - "

cat > /tmp/limit_expected.html << __DATA__
<table border="1" summary="t2t table">
   <thead><tr>      <th>Name</th>      <th>Rank</th>      <th>M Won</th>      </tr></thead>
   <tr>      <td>Ahmadi,Ali</td>      <td>6.08</td>      <td>3</td>    </tr>
   <tr>      <td>Scholnick,Steve</td> <td>5.00</td>      <td>5</td>    </tr>
</table>
__DATA__

cat > /tmp/limit.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>yes</header>
        <oneTable>false</oneTable>
        <nbsp>0</nbsp>
       	<squeeze>1</squeeze>
        <tablesOnly>true</tablesOnly>
		<limit>3</limit>
    </general>
    <table>
        <border>1</border>
    </table>
</t2t>
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --tables --init /tmp/limit.rc --limit 3 < /Users/scholnick/perl/t2t/test/ranks > /tmp/limit_actual.html

results=`diff -b -B -i -w /tmp/limit_expected.html /tmp/limit_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/limit_expected.html /tmp/limit_actual.html /tmp/limit.rc

exit $returnCode

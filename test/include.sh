#!/bin/bash

echo -n "Include - "

cat > /tmp/include_expected.html << __DATA__
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>include</title>
<meta name="generator" content="t2t" />
</head>
<body>
<table border="1" summary="t2t table">
   <thead><tr>      <th>Name</th>      <th>Rank</th>      <th>M Won</th>      <th>M Lost</th>      <th>M %</th>      <th>G Won</th>      <th>G Lost</th>      <th>G %</th>   </tr></thead>
   <tr>      <td>Ahmadi,Ali</td>      <td>6.08</td>      <td>3</td>      <td>1</td>      <td>75.00</td>      <td>11</td>      <td>14</td>      <td>44.00</td>   </tr>
   <tr>      <td>Scholnick,Steve</td> <td>5.00</td>      <td>5</td>      <td>0</td>      <td>100.00</td>      <td>10</td>      <td>2</td>      <td>80.00</td>   </tr>
</table>

</body>
</html>
__DATA__

cat > /tmp/include.rc << __DATA__
<?xml version="1.0"?>
<t2t>
    <general>
        <delim>:</delim>
        <header>yes</header>
        <includeTable>false</includeTable>
        <nbsp>0</nbsp>
       	<squeeze>1</squeeze>
       	<title>include</title>
    </general>
    <table>
        <border>1</border>
    </table>
</t2t>
__DATA__

cat > /tmp/include.append << __DATA__
Appended block
__DATA__

/Users/scholnick/perl/t2t/t2t.pl --init /tmp/include.rc < /Users/scholnick/perl/t2t/test/ranks > /tmp/include_actual.html

results=`diff -b -B -i -w /tmp/include_expected.html /tmp/include_actual.html`

if [ $? == 0 ]; then
  echo "Success"
  returnCode=0
else
  echo "Failure"
  echo $results
  returnCode=1
fi

rm -f /tmp/include_expected.html /tmp/include_actual.html /tmp/include.rc /tmp/include.append

exit $returnCode

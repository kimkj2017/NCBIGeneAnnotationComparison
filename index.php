<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>CSE 466 Project</title>
<link rel='stylesheet' href='css/bootstrap.min.css'>
<link rel='stylesheet' href='css/bootstrap-theme.min.css'>
<script src='js/jquery-3.1.1.slim.js'></script>
<script src='js/bootstrap.min.js'></script>
<style>
* {
  font-family: "San Francisco", "Helvetica Neue", "Helvetica", "Arial", "Courier New";
}
</style>
</head>
<body>
<div class='container' style='max-width: 900px'>
<h1><a href='http://miamioh.edu/cec/academics/departments/cse/academics/course-descriptions/cse-466-566/index.html'>BIO/CSE 466</a> Project: <a href=https://www.ncbi.nlm.nih.gov/'>NCBI</a> Gene Comparison</h1>
  <div class='well'>
    <form class='form-group' action='process.pl' method='post'>
      <div class='form' style='padding-bottom: 10px;'>
      <label for='gid'>Gene ID</label>
      <input id='gid' name='gid' type='text' class='form-control'>
      </div>
      <div class='form' style='padding-bottom: 10px;'>
      <label for='gname'>Gene Name</label>
      <input id='gname' name='gname' type='text' class='form-control'>
      </div>
      <div class='form'>
      <input type='submit' class='btn btn-block btn-primary'>
      </div>
    </form>
    <button class='btn btn-block btn-warning' data-toggle='modal' data-target='#instModal'>General Instruction of Form Submission</a>
  </div>
  <div class='well'>
  <button class='btn btn-block btn-success' data-toggle='modal' data-target='#overviewModal'>Overview of Gene Data Stored in the Database</a>
  </div>
  <!--p>What we need: gene, mRNA, other RNA</p-->
  <footer>
    <p>2016 (C) <a href='mailto:kimk3@miamioh.edu'>Kwangju Kim</a> and <a href='mailto:heidelmr@miamioh.edu'>Martin Heidelman</a>. Supervised by
       <a href='mailto:liangc@miamioh.edu'>Dr. Chun Liang</a> and <a href='mailto:wangk4@miamioh.edu'>Kai Wang</a>. All rights reserved.</p>
  </footer>
</div>
<?php include('inst.php'); ?>
<?php virtual('overview.pl'); ?>
</body>
</html>

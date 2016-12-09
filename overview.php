<!--DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>CSE 466 Project</title>
<link rel='stylesheet' href='css/bootstrap.min.css'>
<link rel='stylesheet' href='css/bootstrap-theme.min.css'>
<script src='js/jquery-3.1.1.slim.js'></script>
<script src='js/bootstrap.min.js'></script>
</head>
<body>
</body>
</html-->

<div class="modal fade bd-example-modal-lg" id="overviewModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h2 class="modal-title" id="myModalLabel">Overview of Gene and Transcript Data</h2>
      </div>
      <div class="modal-body">
        <p><strong>Here, an overview of gene and transcript data stored in our local database is shown.</strong></p>
        <table class="table table-striped">
          <tr>
            <th colspan='2'>Gene Overview</th>
            <th colspan='2'>Transcript Overview</th>
          </tr>
          <tr>
            <th>GFF_NCBI</th>
            <th>Number</th>
            <th>GFF_NCBI</th>
            <th>Number</th>
          </tr>
<?php


?>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


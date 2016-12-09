<!--The following code is for instructions only. Should be invoked with index.php, not individually -->


<!-- Modal -->
<div id="instModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h3 class="modal-title">Instruction</h3>
      </div>
      <div class="modal-body">
        <p><strong>Please read this instruction manual carefully.</strong></p>
        <p>The main purpose of this website is to provide a gene comparison between cats (<i>felis catus</i>) and tigers (<i>panthera tigris</i>).
        Please provide either Gene ID, Gene Name, or both on the form in the main page if you wish to perform comparison.</p>
        <p>Following is how the example form looks like.</p>
        <div class='well'>
          <div class='form'>
            <label>Gene ID</label>
            <input type='text' class='form-control' value='Receives the Gene ID. Ex) 102899061' disabled>
            <label>Gene Name</label>
            <input type='text' class='form-control' value='Receives the Gene Name. Ex) LOC102899061' disabled>
          </div>
        </div>
        <ul>
          <li>Gene ID: Provide NCBI-style Gene ID you wish to look for.</li>
          <li>Gene Name: Provide a specific name of gene(s) you wish to look for.</li>
        </ul>
        <p>After submission, the server will response with the query results given your form data.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>

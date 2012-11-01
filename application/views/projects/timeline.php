<?php Section::inject('page_title', $project->title) ?>
<?php Section::inject('page_action', "Timeline") ?>
<?php Section::inject('active_subnav', 'create') ?>
<?php Section::inject('active_sidebar', 'timeline') ?>
<?php Section::inject('no_page_header', true) ?>
<?php echo Jade\Dumper::_html(View::make('projects.partials.toolbar')->with('project', $project)); ?>
<div class="row-fluid">
  <div class="span3">
    <?php echo Jade\Dumper::_html(View::make('projects.partials.sow_composer_sidebar')->with('project', $project)); ?>
  </div>
  <div class="span9">
    <form method="POST">
      <table class="table timeline-table">
        <thead>
          <tr>
            <th>Deliverable</th>
            <th>Completion Date <?php echo Jade\Dumper::_html(helper_tooltip("Feel free to assign a date as 'TBD' or blank if you're not sure yet.")); ?></th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($deliverables as $deliverable => $date): ?>
            <tr>
              <td>
                <input type="text" name="deliverables[]" placeholder="Deliverable Name" value="<?php echo Jade\Dumper::_text($deliverable); ?>" />
              </td>
              <td>
                <span class="input-append date datepicker">
                  <input class="span3" type="text" name="deliverable_dates[]" value="<?php echo Jade\Dumper::_text($date); ?>" />
                  <span class="add-on">
                    <i class="icon-calendar"></i>
                  </span>
                </span>
                <a class="btn btn-success add-deliverable-button">Add</a>
                <a class="btn remove-deliverable-button">
                  <i class="icon-trash"></i>
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
        <tfoot>
          <tr class="add-deliverable-row">
            <td>
              <input type="text" name="deliverables[]" placeholder="Deliverable Name" data-original-val="" />
            </td>
            <td>
              <span class="input-append date datepicker">
                <input class="span3" type="text" name="deliverable_dates[]" value="" data-original-val="" />
                <span class="add-on">
                  <i class="icon-calendar"></i>
                </span>
              </span>
              <a class="btn btn-success add-deliverable-button">Add</a>
              <a class="btn remove-deliverable-button">
                <i class="icon-trash"></i>
              </a>
            </td>
          </tr>
        </tfoot>
      </table>
      <div class="form-actions">
        <button class="btn btn-primary">Review &rarr;</button>
      </div>
    </form>
  </div>
</div>
<?php
  if (!isset($vendor) && Auth::user() && Auth::user()->vendor) {
    $vendor = Input::old('vendor') ?: Auth::user()->vendor->to_array();
  }

  if (!isset($services) && Auth::user() && Auth::user()->vendor) {
    $services_list = Auth::user()->vendor->services()->lists('id');
    $services = array();
    foreach ($services_list as $key => $val) {
      $services[intval($val)] = true;
    }
  }
?>

<div class="row">

    <fieldset class="span5">
    <h3>Work and Capabilities</h3>

    <label><h5>Your company in 50 words or less</h5></label>
    <textarea name="vendor[more_info]"><?= $vendor["more_info"] ?></textarea>

    <h5>What kind of work does your company do?</h5>
    <?php foreach(Service::all() as $service): ?>
      <label><input type="checkbox" name="services[<?= $service->id ?>]"
                    <?php if (isset($services[$service->id])) echo "checked"; ?> />
        <?= $service->name ?></label>
    <?php endforeach; ?>

    <label><h5>Ballpark average project price</h5></label>
    <select type="text" name="vendor[ballpark_price]">
      <?php foreach(Vendor::$ballpark_prices as $id => $ballpark_price): ?>
        <option value="<?= $id ?>" <?php if ($vendor["ballpark_price"] == $id) echo "selected"; ?>><?= $ballpark_price ?></option>
      <?php endforeach; ?>
    </select>

    <h5>Company links</h5>

    <label>Home page</label>
    <input type="text" name="vendor[homepage_url]" value="<?= $vendor["homepage_url"] ?>" />

    <label>Portfolio</label>
    <input type="text" name="vendor[portfolio_url]" value="<?= $vendor["portfolio_url"] ?>" />

    <label>Public source (e.g. github)</label>
    <input type="text" name="vendor[sourcecode_url]" value="<?= $vendor["sourcecode_url"] ?>" />

    <div class="vendor-image-url">
      <label>An image of your best work</label>
      <input type="text" name="vendor[image_url]" value="<?= $vendor["image_url"] ?>" />

      <label>Preview</label>
      <div class="vendor-image-preview-frame">
        <img />
      </div>
    </div>
  </fieldset>

  <fieldset class="span5">
    <h3>Contact Info</h3>

    <?php if (isset($signup) && $signup): ?>
      <label>Email</label>
      <input type="text" name="user[email]" value="<?= isset($user) ? $user["email"] : "" ?>" />

      <label>Choose a Password</label>
      <input type="password" name="user[password]" />
    <?php endif; ?>

    <label>Company Name</label>
    <input type="text" name="vendor[company_name]" value="<?= $vendor["company_name"] ?>" />

    <label>Person to Contact</label>
    <input type="text" name="vendor[contact_name]" value="<?= $vendor["contact_name"] ?>" />

    <label>Address</label>
    <input type="text" name="vendor[address]" value="<?= $vendor["address"] ?>" />

    <label>City</label>
    <input type="text" name="vendor[city]" value="<?= $vendor["city"] ?>" />

    <label>State</label>
    <select name="vendor[state]">
      <?php foreach(Helper::all_us_states() as $code => $state): ?>
        <option value="<?= $code ?>" <?php if ($vendor["state"] == $code) echo "selected"; ?>><?= $state ?></option>
      <?php endforeach; ?>
    </select>

    <label>Zip</label>
    <input type="text" name="vendor[zip]" value="<?= $vendor["zip"] ?>" />

  </fieldset>

</div>
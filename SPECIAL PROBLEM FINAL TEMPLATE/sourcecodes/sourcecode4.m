//Add New Equipment

<script src="../js/jquery-1.10.2.js"></script>
<script src="javascript/jquery.js"></script>
<script src="javascript/jquery.validate.js"></script>
<?php include ('equip_select.php'); ?>

<div class="row">
    <div class="form-group col-lg-3 col-lg-offset-3">
            <label>Description </label>
    </div>
    <div class="form-group col-lg-3">
                <textarea class="form-control" name="addEquipDesc" rows="3" placeholder="Add description"></textarea>
    </div>
</div>
<div class="row">
    <div class="form-group col-lg-3 col-lg-offset-3">
        <label>Amount </label>
        <div class="input-group">
                <span class="input-group-addon">&#8369</span>
                <input type="text" name="addEquipAmount" class="form-control"/>
                </div>
    </div>                 
    <div class="col-lg-2">
        <label>Qty </label>
        <input type="text" name="addEquipQuantity" class="form-control"/>  
    </div>
</div>
<div class="row">
    <div class="form-group col-lg-3 col-lg-offset-3">
            <label>Expiration Date </label>
    <input class="form-control" name="addEquipExpiryDate" />
    </div>
</div>
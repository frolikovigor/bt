<h1>{lang key="editBillingAdress" section="account data"}</h1>
{include file="snippets/extension.tpl"}
<form id="rechnungsdaten" action="{get_static_route id='jtl.php' params=['editRechnungsadresse' => 1]}" method="post" class="panel-wrap login-form">
    <div id="panel-address-form" class="panel-address-form">
        {$jtl_token}
        {include file='checkout/inc_billing_address_form.tpl'}
        <input type="hidden" name="editRechnungsadresse" value="1" />
        <input type="hidden" name="edit" value="1" />
    </div>
    <div class="form-group">
        {*<input type="submit" class="btn btn-primary submit" value="{lang key="editBillingAdress" section="account data"}" />*}
        <input type="submit" class="btn-d submit" value="Speichern" />
    </div>
</form>

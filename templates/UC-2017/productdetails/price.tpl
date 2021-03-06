
{if $smarty.session.Kundengruppe->darfPreiseSehen}
    <div class="price_wrapper">
    {block name="price-wrapper"}
        {if $Artikel->Preise->fVKNetto==0 && $Artikel->bHasKonfig}
            <span class="price_label price_as_configured">{lang key="priceAsConfigured" section="productDetails"}</span>
        {elseif $Artikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0 === 'N'}
            <span class="price_label price_on_application">{lang key="priceOnApplication" section="global"}</span>
        {else}
            {if $Artikel->nVariationsAufpreisVorhanden == 1 || $Artikel->bHasKonfig}
                {*<span class="price_label pricestarting">{lang key="priceStarting" section="global"} </span>*}
            {elseif $Artikel->Preise->rabatt>0}
                <span class="price_label nowonly">{lang key="nowOnly" section="global"} </span>
            {else}
                {*<span class="price_label only">{lang key="only" section="global"} </span>*}
            {/if}
            {if !empty($price_image)}
                <span class="price_img">{$price_image}</span>
            {else}

                {assign var="getPrice" value=""}

                {*{if $Artikel->Preise->Sonderpreis_aktiv}*}
                    {*{assign var="getPrice" value=$Artikel->Preise->alterVKLocalized[$NettoPreise]}*}
                {*{else}*}
                    {*{assign var="getPrice" value=$Artikel->cUVPLocalized}*}
                {*{/if}*}


                {if $Artikel->fUVP>$Artikel->Preise->fVKBrutto || $Artikel->Preise->Sonderpreis_aktiv}
                    {assign var="getPrice" value=$Artikel->cUVPLocalized}
                {/if}


                {getDiscount price=$getPrice origin=$Artikel->Preise->cVKLocalized[$NettoPreise] assign="Discount"}

                {if ($Artikel->fUVP>$Artikel->Preise->fVKBrutto || $Artikel->Preise->Sonderpreis_aktiv) && ($Discount >= 2)}

                    <div class="goods__price">
                        <div class="price__promo">
                            <span class="price__old">
                                {$getPrice}
                            </span>
                            <span class="price__red">
                                {$Artikel->Preise->cVKLocalized[$NettoPreise]}
                            </span>
                        </div>
                    </div>

                    <span class="goods__label"><span class="label__text">Sale</span></span>
                    <span class="goods__promo"><span class="label__text label__text_promo" data-price="{$getPrice}" data-price2="{$Artikel->Preise->cVKLocalized[$NettoPreise]}">{$Discount}%</span></span>
                {else}
                    <div class="goods__price">
                        <div class="price__origin">
                            <span>{$Artikel->Preise->cVKLocalized[$NettoPreise]}</span>
                        </div>
                    </div>
                {/if}
            {/if}

            {if $tplscope === 'detail'}
                {block name="price-snippets"}
                    <meta itemprop="price" content="{$Artikel->Preise->fVKBrutto}">
                    <meta itemprop="priceCurrency" content="{$smarty.session.Waehrung->cName}">
                {/block}
                <div class="price-note">
                {if $Artikel->cEinheit && ($Artikel->fMindestbestellmenge > 1 || $Artikel->fAbnahmeintervall > 1)}
                    <span class="price_label per_unit"> {lang key="vpePer" section="global"} 1 {$Artikel->cEinheit}</span>
                {/if}

                {* Grundpreis *}
                {if !empty($Artikel->cLocalizedVPE)}
                    {block name="detail-base-price"}
                        <div class="base-price text-nowrap">
                            <span class="value">{$Artikel->cLocalizedVPE[$NettoPreise]}</span>
                        </div>
                    {/block}
                {/if}

                {block name="detail-vat-info"}
                    <p class="vat_info text-muted top5">
                        {include file='snippets/shipping_tax_info.tpl' taxdata=$Artikel->taxData}
                    </p>
                {/block}

                {if $Artikel->oPreisradar}
                    <div class="priceradar">
                        {lang key="youSave" section="productDetails"}
                        <span class="value">{$Artikel->oPreisradar->fDiffLocalized[$NettoPreise]}
                            ({$Artikel->oPreisradar->fProzentDiff} %)
                        </span>
                    </div>
                {/if}

                {if $Artikel->Preise->Sonderpreis_aktiv && $Einstellungen.artikeldetails.artikeldetails_sonderpreisanzeige==2}
                    <div class="instead_of old_price">{lang key="oldPrice" section="global"}:
                        <del class="value">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del>
                    </div>
                {elseif !$Artikel->Preise->Sonderpreis_aktiv && $Artikel->Preise->rabatt > 0}
                    {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige == 3 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
                        <div class="old_price">{lang key="oldPrice" section="global"}:
                            <del class="value text-nowrap">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del>
                        </div>
                    {/if}
                    {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige == 2 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
                        <div class="discount">{lang key="discount" section="global"}:
                            <span class="value text-nowrap">{$Artikel->Preise->rabatt}%</span></div>
                    {/if}
                {/if}

                {if $Einstellungen.artikeldetails.artikeldetails_uvp_anzeigen === 'Y' && $Artikel->fUVP>0}
                    {* --- Unverbindliche Preisempfehlung anzeigen? Aktuell wegen $UVPlocalized nur auf Detailseite moeglich --- *}
                    <div class="suggested-price">
                        <abbr title="{lang key="suggestedPriceExpl" section="productDetails"}">{lang key="suggestedPrice" section="productDetails"}</abbr>:
                        <del class="value text-nowrap">{$UVPlocalized}</del>
                    </div>
                    {* Preisersparnis zur UVP anzeigen? *}
                    {if isset($Artikel->SieSparenX) && $Artikel->SieSparenX->anzeigen == 1 && $Artikel->SieSparenX->nProzent > 0 && !$NettoPreise}
                        <div class="yousave">({lang key="youSave" section="productDetails"}
                            <span class="percent">{$Artikel->SieSparenX->nProzent}
                                %</span>, {lang key="thatIs" section="productDetails"}
                            <span class="value text-nowrap">{$Artikel->SieSparenX->cLocalizedSparbetrag}</span>)
                        </div>
                    {/if}
                {/if}

                {* --- Staffelpreise? --- *}
                {if !empty($Artikel->staffelPreis_arr)}
                    <div class="differential-price">
                    {block name="detail-differential-price"}
                        <table class="table table-condensed table-hover">
                            <thead>
                            <tr>
                                <th class="text-right">{lang key="fromDifferential" section="productOverview"}{if $Artikel->cEinheit} {$Artikel->cEinheit}{/if}</th>
                                <th class="text-right">{lang key="pricePerUnit" section="productDetails"}</th>
                                {if !empty($Artikel->cLocalizedVPE)}<th></th>{/if}
                            </tr>
                            </thead>
                            <tbody>
                            {foreach $Artikel->staffelPreis_arr as $differentialPrice}
                                {if $differentialPrice.nAnzahl > 0}
                                    <tr>
                                        <td class="text-right">{$differentialPrice.nAnzahl}</td>
                                        <td class="text-right">{$differentialPrice.cPreisLocalized[$NettoPreise]}</td>
                                        {if !empty($differentialPrice.cBasePriceLocalized)}<td class="text-muted">{$differentialPrice.cBasePriceLocalized[$NettoPreise]}</td>{/if}
                                    </tr>
                                {/if}
                            {/foreach}
                            </tbody>
                        </table>
                    {/block}
                    </div>{* /differential-price *}
                {/if}
                </div>{* /price-note *}
            {else}{* scope productlist *}
                <div class="price-note">
                {if $Artikel->Preise->Sonderpreis_aktiv && isset($Einstellungen.artikeluebersicht) && $Einstellungen.artikeluebersicht.artikeluebersicht_sonderpreisanzeige==2}
                    <div class="instead-of old-price">
                        <small class="text-muted">
                            {lang key="oldPrice" section="global"}:
                            <del class="value">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del>
                        </small>
                    </div>
                {elseif !$Artikel->Preise->Sonderpreis_aktiv && $Artikel->Preise->rabatt > 0 && isset($Einstellungen.artikeluebersicht)}
                    {if $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige == 3 || $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige==4}
                        <div class="old-price">
                            <small class="text-muted">
                                {lang key="oldPrice" section="global"}:
                                <del class="value text-nowrap">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del>
                            </small>
                        </div>
                    {/if}
                    {if $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige == 2 || isset($Einstellungen.artikeluebersicht) && $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige==4}
                        <div class="discount">
                            <small class="text-muted">
                                {lang key="discount" section="global"}:
                                <span class="value text-nowrap">{$Artikel->Preise->rabatt}%</span>
                            </small>
                        </div>
                    {/if}
                {/if}
                </div>{* /price-note *}
            {/if}
        {/if}
    {/block}
    </div>{* /price_wrapper *}
{else}

{/if}
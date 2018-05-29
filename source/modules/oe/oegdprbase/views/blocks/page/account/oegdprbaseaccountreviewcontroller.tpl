[{if $oViewConf->oeGdprBaseIsUserAllowedToManageOwnReviews()}]
    [{block name="oegdprbase_account_manage_reviews"}]
        [{if $oViewConf->getActiveTheme() == 'azure'}]
            [{include file="oegdprbaseaccountreviewcontroller_azure.tpl"}]
        [{elseif strpos($oViewConf->getActiveTheme(), "roxid") !== false}]
            [{include file="oegdprbaseaccountreviewcontroller_roxid.tpl" }]
        [{else}]
            [{include file="oegdprbaseaccountreviewcontroller_flow.tpl" }]
        [{/if}]
    [{/block}]
[{/if}]

[{if $oView->oeGdprBaseIsUserAllowedToManageOwnReviews()}]
    <dl>
        <dt>
            <a href="[{oxgetseourl ident=$oViewConf->getSelfLink()|cat:"cl=oegdprbaseaccountreviewcontroller"}]">[{oxmultilang ident="OEGDPRBASE_MY_REVIEWS"}]</a>
        </dt>
        <dd>[{oxmultilang ident="OEGDPRBASE_MY_REVIEWS"}]</dd>
    </dl>
[{/if}]

[{if $oView->oeGdprBaseIsUserAllowedToDeleteOwnAccount()}]
    [{block name="oegdprbase_account_delete_my_account"}]
        <form name="delete_my_account" action="[{$oViewConf->getSelfActionLink()}]" method="post">
            <div class="hidden">
                [{$oViewConf->getHiddenSid()}]
                <input type="hidden" name="cl" value="account">
                <input type="hidden" name="fnc" value="oeGdprBaseDeleteAccount">
            </div>
            <button id="oegdprbase_delete_my_account_button" class="btn btn-danger pull-left" data-toggle="modal" data-target="#oegdprbase_delete_my_account_confirmation">
                <i class="fa fa-trash"></i>
                [{oxmultilang ident="OEGDPRBASE_DELETE_MY_ACCOUNT"}]
            </button>
            [{capture assign="deleteaccountjs"}]
                $(window).on('load', function() {
                    var logoutLink = $(".accountDashboardView").next(".row").find("a[role=\'getLogoutLink\']");
                    var deleteButton = $("#oegdprbase_delete_my_account_button");

                    logoutLink.before(deleteButton);
                    deleteButton.show();

                    $(deleteButton).bind("click", function(ev) {
                        ev.preventDefault();
                        var form = $(this).parents("form");
                        bootbox.confirm({
                            title: "[{oxmultilang ident="OEGDPRBASE_DELETE_MY_ACCOUNT_CONFIRMATION_QUESTION"}]",
                            message: "[{oxmultilang ident="OEGDPRBASE_DELETE_MY_ACCOUNT_WARNING"}]",
                            buttons: {
                                cancel: {
                                    label: '[{oxmultilang ident="OEGDPRBASE_CANCEL_DELETE_ACCOUNT"}]'
                                },
                                confirm: {
                                    label: '[{oxmultilang ident="OEGDPRBASE_DELETE_ACCOUNT_CONFIRMATION"}]',
                                    className: 'btn-danger'
                                }
                            },
                            callback: function (result) {
                                if(!result) { return; }
                                form.submit();
                            }
                        });
                    });
                });
            [{/capture}]
            [{oxscript add=$deleteaccountjs}]
        </form>
    [{/block}]
[{/if}]

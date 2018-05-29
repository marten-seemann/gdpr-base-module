[{capture append="oxidBlock_content"}]

    [{oxscript include="js/widgets/oxlistremovebutton.min.js" priority=10}]

    [{block name="oegdprbase_account_reviewlist_header"}]
        [{assign var="template_title" value="OEGDPRBASE_MY_REVIEWS"|oxmultilangassign}]
        <h1 class="page-header">[{$oView->getTitle()}]</h1>
    [{/block}]

    [{block name="oegdprbase_account_reviewlist_list"}]
        <div id="review">
            [{if $oView->oeGdprBaseGetReviewAndRatingItemsCount() }]
                <div class="spacer"></div>
                <div class="reviews-landscape">
                    [{foreach from=$oView->oeGdprBaseGetReviewList() item=review name=ReviewsCounter}]
                        [{block name="oegdprbase_account_reviewlist_item"}]
                            <div class="panel panel-default" id="reviewName_[{$smarty.foreach.ReviewsCounter.iteration}]" itemprop="review" itemscope itemtype="http://schema.org/Review">
                                <div class="panel-heading">
                                    <div class="row">
                                        <div class="col-md-6 date">
                                            <span>
                                                <time itemprop="datePublished" datetime="[{$review->getCreatedAt()|date_format:"%Y-%m-%d"}]">[{$review->getCreatedAt()|date_format:"%d.%m.%Y"}]</time>
                                            </span>
                                        </div>
                                        <div class="col-md-10 articleTitle">
                                            <span itemprop="itemreviewed">[{$review->getObjectTitle()|truncate:60}]</span>
                                        </div>
                                        <div class="col-md-6 rating text-right">
                                            [{if $review->getRating()}]
                                                <div itemprop="reviewRating" itemscope itemtype="http://schema.org/Rating">
                                                    [{section name="starRatings" start=0 loop=5}]
                                                        [{if $review->getRating() >= $smarty.section.starRatings.iteration}]
                                                            <i class="fa fa-star"></i>
                                                        [{else}]
                                                            <i class="fa fa-star-o"></i>
                                                        [{/if}]
                                                    [{/section}]
                                                </div>
                                            [{/if}]
                                        </div>
                                        [{block name="oegdprbase_account_reviewlist_item_action"}]
                                            <div class="col-md-2 pull-right">
                                                <form class="delete-review" action="[{$oViewConf->getSslSelfLink()}]" method="post" id="remove_review_[{$smarty.foreach.ReviewsCounter.iteration}]">
                                                    [{$oViewConf->getNavFormParams()}]
                                                    [{$oViewConf->getHiddenSid()}]
                                                    <input name="pgNr" value="[{$oView->getActPage()}]"  type="hidden">
                                                    <input type="hidden" name="cl" value="oegdprbaseaccountreviewcontroller">
                                                    <input type="hidden" name="fnc" value="oegdprbasedeletereviewandrating">
                                                    <input name="reviewId" value="[{$review->getReviewId()}]" type="hidden">
                                                    <input name="ratingId" value="[{$review->getRatingId()}]" type="hidden">
                                                    <button type="submit" class="btn btn-danger btn-block" title="[{oxmultilang ident="OEGDPRBASE_DELETE_REVIEW_AND_RATING"}]" data-toggle="modal" data-target="#delete_review_[{$smarty.foreach.ReviewsCounter.iteration}]"><i class="fa fa-trash"></i></button>
                                                </form>
                                            </div>
                                        [{/block}]
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                                [{if $review->getReviewText()}]
                                    <div class="panel-body" id="reviewText_[{$smarty.foreach.ReviewsCounter.iteration}]" itemprop="description">[{$review->getReviewText()}]</div>
                                [{/if}]
                            </div>
                        [{/block}]
                        [{capture assign="deletereviewjs"}]
                            $(".delete-review button").bind("click", function(ev) {
                                ev.preventDefault();
                                var form = $(this).parents("form");
                                console.log(form);
                                bootbox.confirm({
                                    message: "[{oxmultilang ident="OEGDPRBASE_DELETE_REVIEW_CONFIRMATION_QUESTION"}]",
                                    //message: "[{oxmultilang ident="OEGDPRBASE_DELETE_SHIPPING_ADDRESS"}]",
                                    buttons: {
                                        confirm: {
                                            label: '[{oxmultilang ident="OEGDPRBASE_DELETE"}]',
                                            className: 'btn-danger'
                                        },
                                        cancel: {
                                            label: '[{oxmultilang ident="CANCEL"}]',
                                        }
                                    },
                                    callback: function(result) {
                                        if(!result) { return; }
                                        form.submit();
                                        return false;
                                    }
                                });
                            });
                        [{/capture}]
                        [{oxscript add=$deletereviewjs}]
                    [{/foreach}]
                </div>
            [{else}]
                [{block name="oegdprbase_account_reviewlist_no_reviews_available"}]
                    <div class="alert alert-info">
                        [{oxmultilang ident="OEGDPRBASE_REVIEWS_NOT_AVAILABLE"}]
                    </div>
                [{/block}]
            [{/if}]
        </div>
    [{/block}]

    [{block name="oegdprbase_account_reviewlist_locator"}]
        [{include file="widget/locator/listlocator.tpl" locator=$oView->getPageNavigation() place="bottom"}]
    [{/block}]

    [{insert name="oxid_tracker" title=$template_title}]

[{/capture}]
[{capture append="oxidBlock_sidebar"}]
    [{include file="page/account/inc/account_menu.tpl" active_link="reviewlist"}]
[{/capture}]
[{include file="layout/page.tpl" sidebar="Left"}]

class AccountAppController extends AppController

  KD.registerAppClass this,
    name         : "Account"
    route        : "/:name?/Account"
    behavior     : "hideTabs"
    hiddenHandle : yes
    navItem      :
      title      : "Account"
      path       : "/Account"
      order      : 70
      type       : "account"
      loggedIn   : yes

  items =
    personal :
      title : "Personal"
      items : [
        { title : "Login & Email",        listHeader: "Email & username",           listType: "username",       id : 10,      parentId : null }
        { title : "Password & Security",  listHeader: "Password & Security",        listType: "security",       id : 20,      parentId : null }
        { title : "E-mail Notifications", listHeader: "E-mail Notifications",       listType: "emailNotifications", id : 22,  parentId : null }
        { title : "Linked accounts",      listHeader: "Your Linked Accounts",       listType: "linkedAccounts", id : 30,      parentId : null }
        { title : "Referrals",            listHeader: "Referrals ",                 listType: "referralSystem", id : 40,      parentId : null }
      ]
    billing :
      title : "Billing"
      items : [
        { title : "Payment methods",      listHeader: "Your Payment Methods",       listType: "methods",        id : 10,      parentId : null }
        { title : "Your subscriptions",   listHeader: "Your Active Subscriptions",  listType: "subscriptions",  id : 20,      parentId : null }
        { title : "Billing history",      listHeader: "Billing History",            listType: "history",        id : 30,      parentId : null }
      ]
    develop :
      title : "Develop"
      items : [
        { title : "SSH keys",             listHeader: "Your SSH Keys",              listType: "keys",           id : 5,       parentId : null }
        { title : "Koding Keys",          listHeader: "Your Koding Keys",           listType: "kodingKeys",     id : 10,      parentId : null }
      ]
    danger  :
      title : "Danger"
      items : [
        { title : "Delete Account",       listHeader: "Danger Zone",                listType: "delete",         id : 5,       parentId : null }
      ]
      # kites :
      #   title : "Kites"
      #   items : [
      #     { title : "My Kites",             listHeader: "Your own Kites",             listType: "myKiteList",     id : 10,      parentId : null }
      #     { title : "All Kites",            listHeader: "Your 3rd Party Kites",       listType: "kiteList",       id : 20,      parentId : null }
      #   ]

  constructor:(options={}, data)->

    options.view = new KDView cssClass : "content-page"

    super options, data

    @itemsOrdered = []

  loadView:(mainView)->

    # SET UP VIEWS
    @navController = new AccountSideBarController
      domId : "account-nav"
    navView = @navController.getView()

    @wrapperController = new AccountContentWrapperController
      view    : wrapperView = new KDView
        domId : "account-content-wrapper"

    #ADD CONTENT SECTIONS
    @navController.sectionControllers = []
    @wrapperController.sectionLists = []
    for own sectionKey, section of items
      do =>
        @navController.sectionControllers.push lc = new AccountNavigationController
          wrapper     : no
          scrollView  : no
          viewOptions :
            type      : sectionKey
            cssClass  : "settings-menu"
          itemClass   : AccountNavigationLink
        , section

        navView.addSubView lc.getView()
        navView.addSubView new KDCustomHTMLView tagName : "hr"

        lc.getView().on 'ItemWasAdded', (view, index)=>
          view.on "click", =>
            @wrapperController.scrollTo @indexOfItem view.getData()

      for own itemKey,item of section.items
        @itemsOrdered.push item
        section.id = sectionKey
        wrapperView.addSubView wrapper = new AccountListWrapper
          cssClass : "settings-list-wrapper #{__utils.slugify(item.title)}"
        ,{item,section}
        @wrapperController.sectionLists.push wrapper

    navView.setPartial """
      <div class="kdview kdlistview">
      <h3>Legal</h3>
      <div class="kdview kdlistitemview newpage"><a href="/tos.html" target="_blank">Terms of service <span class="icon new-page"></span></a></div>
      <div class="kdview kdlistitemview newpage"><a href="/privacy.html" target="_blank">Privacy policy <span class="icon new-page"></span></a></div>
      </div>
      """

    # SET UP SPLIT VIEW AND TOGGLERS
    mainView.addSubView @split = split = new SplitView
      domId     : "account-split-view"
      sizes     : [188, null]
      views     : [navView, wrapperView]
      minimums  : [null, null]
      resizable : yes

    [panel0, panel1] = split.panels

    panel1.on "scroll", (event)=> @contentScrolled panel1, event

    panel0.addSubView @leftToggler = new KDView
      cssClass : "account-sidebar-toggler left"
      click    : => @toggleSidebar show:no

    split.addSubView @rightToggler = new KDView
      cssClass : "account-sidebar-toggler right hidden"
      click    : => @toggleSidebar show:yes

    @_windowDidResize()
    KD.getSingleton("windowController").registerWindowResizeListener @

    @utils.wait => @split._windowDidResize()

  contentScrolled:(pubInst,event)->
    @__lastScrollTop or= 0
    newScrollTop = pubInst.$().scrollTop()
    return if @__lastScrollTop is newScrollTop

    topIndex = @wrapperController.getSectionIndexForScrollOffset newScrollTop
    @navController.setActiveNavItem topIndex

    @__lastScrollTop = newScrollTop

  _windowDidResize:->
    lastWrapper = @wrapperController.sectionLists[@wrapperController.sectionLists.length-1]
    lastWrapper.setHeight @navController.getView().getHeight()

  fetchProviders:->

  showReferrerModal:->
    referrerCode      = KD.whoami().profile.nickname
    shareUrl          = "#{location.origin}/?r=#{referrerCode}"
    JReferrableEmail  = KD.remote.api.JReferrableEmail

    referrerModal = new KDModalViewWithForms
      title                   : "Get free space up to 16GB"
      overlay                 : yes
      tabs                    :
        navigable             : no
        goToNextFormOnSubmit  : no
        hideHandleContainer   : yes
        forms                 :
          "share"             :
            customView        : KDCustomHTMLView
            partial           : "If anyone registers with your referral code, you will get \
                                250MB free disk space for your VM. Up to <strong>16GB</strong>"
          "invite"            :
            customView        : KDCustomHTMLView

    tabs         = referrerModal.modalTabs
    shareTab     = tabs.forms["share"]
    inviteTab    = tabs.forms["invite"]

    # Sharetab #

    shareTab.addSubView urlInput = new KDInputView
      defaultValue            : shareUrl
      cssClass                : "share-url-input"
      disabled                : yes

    shareTab.addSubView showGmailContacts = new KDButtonView
      title                   : "Invite friends from Gmail"
      callback                : ->
        tabs.showPaneByName     "invite"
        referrerModal.setTitle  "Invite your Gmail contacts"

    # inviteTab #
    inviteTab.addSubView gmailContactsList = new KDListView

    JReferrableEmail.getUninvitedEmails (err, contacts) ->
      for contact in contacts
        {email, invited} = contact
        gmailContactsList.addItemView new gmailContactsListItem
          email   : email
          invited : invited

  toggleSidebar:(options)->
    {show} = options
    controller = @

    split = @split
    if show
      split.showPanel 0, ->
        controller.rightToggler.hide()
        controller.leftToggler.show()
    else
      split.hidePanel 0, ->
        controller.rightToggler.show()
        controller.leftToggler.hide()

  indexOfItem:(item)->
    @itemsOrdered.indexOf item

class gmailContactsListItem extends KDListItemView
  constructor:(options={})->
    options.cssClass = "gmail-contact-item"
    options.invited ?= no
    super options

    @isSelected = no

  partial:->
    """
      #{@getOption "email"}
    """

  click:->
    @isSelected = !@isSelected




















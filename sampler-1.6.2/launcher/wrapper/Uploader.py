def __add_headers(upload, contributor):
    contribution = contributor.upload_headers()
    for key in contribution:
        upload.headers['sampler-' + key] = contribution[key]


def upload(app, user, outcome, accept):
    '''Upload the results of a single run.'''

    reporting_url = user.reporting_url()
    if reporting_url and outcome.reports:

        # upload in the background, in case the network is slow
        import os
        if os.fork() > 0:
            return

        # compress reports in preparation for upload
        import Upload
        upload = Upload.Upload(outcome.reports)

        # collect headers from various contributors
        import SamplerConfig
        upload.headers['sampler-version'] = SamplerConfig.version
        upload.headers['accept'] = accept
        __add_headers(upload, app)
        __add_headers(upload, outcome)

        # install our special redirect hander
        import urllib2
        import RedirectHandler
        redirect = RedirectHandler.RedirectHandler()
        urllib2.install_opener(urllib2.build_opener(redirect))

        # post the upload and read server's response
        request = urllib2.Request(reporting_url, upload.body(), upload.headers)
        reply = urllib2.urlopen(request)

        # server may have requested a permanent URL change
        if redirect.permanent:
            # !!!: sanity check this before applying it
            # !!!: don't apply change if it is the same as the old value
            user.change_reporting_url(redirect.permanent)

        # server may have requested a sparsity change
        if reply.info().has_key('sampler-change-sparsity'):
            # !!!: sanity check this before applying it
            # !!!: don't apply change if it is the same as the old value
            user.change_sparsity(int(reply.info()['sampler-change-sparsity']))

        # server may have posted a message for the user
        message = reply.read()
        if message and 'DISPLAY' in os.environ:
            base = reply.geturl()
            content_type = reply.info()['content-type']
            del reply
            import ServerMessage
            dialog = ServerMessage.ServerMessage(base, content_type, message)
            dialog.run()

        # child is done; exit without fanfare
        os._exit(0)

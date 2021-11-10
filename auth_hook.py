import zap_auth
import zap_config
import zap_blindxss
import os
import traceback
import logging
import time

config = zap_config.ZapConfig()

# Triggered when running a script directly (ex. python zap-baseline.py ...)
def start_docker_zap(docker_image, port, extra_zap_params, mount_dir):
    config.load_config(extra_zap_params)

# Triggered when running from the Docker image
def start_zap(port, extra_zap_params):
    config.load_config(extra_zap_params)

def zap_started(zap, target):
    try:
        # ZAP Docker scripts reset the target to the root URL
        if target.count('/') > 2:
            # The url can include a valid path, but always reset to spider the host
            target = target[0:target.index('/', 8)+1]

        scan_policy = 'Default Policy'
        zap.ascan.update_scan_policy(scanpolicyname=scan_policy , attackstrength="LOW")
        
        auth = zap_auth.ZapAuth(config)
        auth.authenticate(zap, target)

        zap_blindxss.load(config, zap)
    except Exception:
        logging.error("error in zap_started: %s", traceback.print_exc())
        os._exit(1)

    return zap, target


def zap_active_scan(zap, target, policy):
    
    ## Do custom ajax spider
    logging.info("Do custom ajax_spider")
    navigate_url = config.first_navigate_url

    # set global variable,load and enable script to load session
    zap.script.set_global_var('navigateUrl',navigate_url)
    zap.script.load('load_session_storage','selenium','Oracle Nashorn','/home/zap/.ZAP_D/scripts/scripts/active/custom_session.js')
    zap.script.enable('load_session_storage')
    logging.info('navigate_url: %s',navigate_url)

    ## ajax spider scan
    zap.ajaxSpider.scan(url=navigate_url,contextname='ctx-zap-docker')

    while True:
        if (zap.ajaxSpider.status != "running"):
            zap.script.disable('load_session_storage') ## disable script after finish
            break
        logging.info("Custom spider status: %s",zap.ajaxSpider.status)
        time.sleep(10)

    try:
        logging.info("All urls from zap")
        for url in zap.core.urls(None):
            logging.info("url: %s",url)
    
    except Exception:
        logging.error("error in zap_ajax_spider: %s", traceback.print_exc())
        os._exit(1)

def zap_pre_shutdown(zap):
    logging.debug("Overview of spidered URL's:")
    for url in zap.spider.all_urls:
        logging.debug("found: %s", url)

#!/usr/bin/env python3

# This script helps to provision PyHSS from commandline

import argparse
import requests
import pprint
from urllib.parse import urljoin


def createAPN(baseurl, **kwargs):
    upstream_payload = {
        "apn_id": 0,
        "apn": "string",
        "ip_version": 0,
        "pgw_address": "string",
        "sgw_address": "string",
        "charging_characteristics": "stri",
        "apn_ambr_dl": 0,
        "apn_ambr_ul": 0,
        "qci": 0,
        "arp_priority": 0,
        "arp_preemption_capability": True,
        "arp_preemption_vulnerability": True,
        "charging_rule_list": "string"
    }

    payload = {}

    # override the values in payload with values from kwargs
    for k, v in kwargs.items():
        assert k in upstream_payload, f"Invalid key '{k}'"
        payload[k] = v

    # PUT the payload to the URL
    r = requests.put(urljoin(baseurl, "/apn/"), json=payload)

    assert r.status_code == 200, f"Failed to create APN: {r.text}"

    return r.json()["apn_id"]


def lookupAPNIdByName(baseurl, apn):
    r = requests.get(urljoin(baseurl, "/apn/list"))
    assert r.status_code == 200, f"Failed to lookup APN: {r.text}"
    apns = r.json()

    res = None

    for a in apns:
        if a["apn"] == apn:
            if res is not None:
                raise Exception(f"Multiple APNs with name '{apn}'")
            res = a["apn_id"]
    return res


def createAUC(baseurl, **kwargs):
    upstream_payload = {
        "auc_id": 0,
        "ki": "string",
        "opc": "string",
        "amf": "stri",
        "sqn": 0,
        "iccid": "string",
        "imsi": "string",
        "batch_name": "string",
        "sim_vendor": "string",
        "esim": True,
        "lpa": "string",
        "pin1": "string",
        "pin2": "string",
        "puk1": "string",
        "puk2": "string",
        "kid": "string",
        "psk": "string",
        "des": "string",
        "adm1": "string",
        "misc1": "string",
        "misc2": "string",
        "misc3": "string",
        "misc4": "string"
    }

    payload = {}

    # override the values in payload with values from kwargs
    for k, v in kwargs.items():
        assert k in upstream_payload, f"Invalid key '{k}'"
        payload[k] = v

    # PUT the payload to the URL
    r = requests.put(urljoin(baseurl, "/auc/"), json=payload)

    assert r.status_code == 200, f"Failed to create AUC: {r.text}"

    return r.json()["auc_id"]


def lookupAUCIdByIMSI(baseurl, imsi):
    r = requests.get(urljoin(baseurl, "/auc/list"))
    assert r.status_code == 200, f"Failed to lookup AUC: {r.text}"
    aucs = r.json()

    res = None

    for a in aucs:
        if a["imsi"] == imsi:
            if res is not None:
                raise Exception(f"Multiple AUCs with IMSI '{imsi}'")
            res = a["auc_id"]
    return res


def createSubscriber(baseurl, **kwargs):
    upstream_payload = {
        "subscriber_id": 0,
        "imsi": "string",
        "enabled": True,
        "auc_id": 0,
        "default_apn": 0,
        "apn_list": "string",
        "msisdn": "string",
        "ue_ambr_dl": 0,
        "ue_ambr_ul": 0,
        "nam": 0,
        "subscribed_rau_tau_timer": 0,
        "serving_mme": "string",
        "serving_mme_timestamp": "2023-12-14T09:15:51.134Z",
        "serving_mme_realm": "string",
        "serving_mme_peer": "string"
    }

    payload = {}

    # override the values in payload with values from kwargs
    for k, v in kwargs.items():
        assert k in upstream_payload, f"Invalid key '{k}'"
        payload[k] = v

    # PUT the payload to the URL
    r = requests.put(urljoin(baseurl, "/subscriber/"), json=payload)

    assert r.status_code == 200, f"Failed to create Subscriber: {r.text}"

    return r.json()["subscriber_id"]


def lookupSubscriberIdByIMSI(baseurl, imsi):
    r = requests.get(urljoin(baseurl, "/subscriber/list"))
    assert r.status_code == 200, f"Failed to lookup Subscriber: {r.text}"
    subscribers = r.json()

    res = None

    for s in subscribers:
        if s["imsi"] == imsi:
            if res is not None:
                raise Exception(f"Multiple Subscribers with IMSI '{imsi}'")
            res = s["subscriber_id"]
    return res


def createIMSSubscriber(baseurl, **kwargs):
    upstream_payload = {
        "ims_subscriber_id": 0,
        "msisdn": "string",
        "msisdn_list": "string",
        "imsi": "string",
        "ifc_path": "string",
        "sh_profile": "string",
        "scscf": "string",
        "scscf_timestamp": "2023-12-14T09:25:58.506Z",
        "scscf_realm": "string",
        "scscf_peer": "string"
    }
    payload = {}

    # override the values in payload with values from kwargs
    for k, v in kwargs.items():
        assert k in upstream_payload, f"Invalid key '{k}'"
        payload[k] = v

    # PUT the payload to the URL
    r = requests.put(urljoin(baseurl, "/ims_subscriber/"), json=payload)

    assert r.status_code == 200, f"Failed to create IMS Subscriber: {r.text}"

    return r.json()["ims_subscriber_id"]


def lookupIMSSubscriberIdByIMSI(baseurl, imsi):
    r = requests.get(urljoin(baseurl, "/ims_subscriber/list"))
    assert r.status_code == 200, f"Failed to lookup IMS Subscriber: {r.text}"
    imssubscribers = r.json()

    res = None

    for s in imssubscribers:
        if s["imsi"] == imsi:
            if res is not None:
                raise Exception(f"Multiple IMS Subscribers with IMSI '{imsi}'")
            res = s["ims_subscriber_id"]
    return res


def main():
    parser = argparse.ArgumentParser(
        description='PyHSS Tool',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-u', '--url', help='PyHSS URL',
                        default="http://localhost:8080/")
    parser.add_argument('--mcc', help="MCC", default="901")
    parser.add_argument('--mnc', help="MNC", default="70")
    parser.add_argument('-i', '--imsi', help="IMSI", required=True)
    parser.add_argument('-m', '--msisdn', help="MSISDN", required=True)
    parser.add_argument('-k', '--ki', help="Ki", required=True)
    parser.add_argument('-o', '--opc', help="OPc", required=True)
    args = parser.parse_args()

    baseurl = args.url

    mcc = args.mcc
    mnc = args.mnc
    imsi = args.imsi
    msisdn = args.msisdn
    ki = args.ki
    opc = args.opc

    mccnum = int(mcc)
    mncnum = int(mnc)
    domain = f"mnc{mncnum:03d}.mcc{mccnum:03d}.3gppnetwork.org"

    # Create internet and ims APNs if they don't exist
    internet_apn_id = lookupAPNIdByName(baseurl, "internet")
    ims_apn_id = lookupAPNIdByName(baseurl, "ims")

    if internet_apn_id is None:
        internet_apn_id = createAPN(
            baseurl, apn="internet", apn_ambr_dl=0, apn_ambr_ul=0)

    if ims_apn_id is None:
        ims_apn_id = createAPN(
            baseurl, apn="ims", apn_ambr_dl=0, apn_ambr_ul=0)

    # Create AUC, Subscriber and IMS Subscriber if they don't exist
    auc_id = lookupAUCIdByIMSI(baseurl, imsi)
    sub_id = lookupSubscriberIdByIMSI(baseurl, imsi)
    ims_sub_id = lookupIMSSubscriberIdByIMSI(baseurl, imsi)

    if auc_id is None:
        auc_id = createAUC(baseurl, ki=ki, opc=opc,
                           amf="8000", sqn=0, imsi=imsi)

    if sub_id is None:
        apn_list = ",".join([str(x) for x in [internet_apn_id, ims_apn_id]])
        sub_id = createSubscriber(baseurl,
                                  imsi=imsi,
                                  enabled=True,
                                  auc_id=auc_id,
                                  default_apn=internet_apn_id,
                                  apn_list=apn_list,
                                  msisdn=msisdn,
                                  ue_ambr_dl=0,
                                  ue_ambr_ul=0,
                                  )

    if ims_sub_id is None:
        ims_sub_id = createIMSSubscriber(baseurl, imsi=imsi,
                                         msisdn=msisdn,
                                         sh_profile="string",
                                         scscf_peer=f"scscf.ims.{domain}",
                                         msisdn_list=str([msisdn]),
                                         ifc_path="default_ifc.xml",
                                         scscf=f"sip:scscf.ims.{domain}:6060",
                                         scscf_realm=f"ims.{domain}")


if __name__ == "__main__":
    main()

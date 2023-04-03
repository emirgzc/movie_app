// To parse this JSON data, do
//
//     final whereToWatch = whereToWatchFromJson(jsonString);

import 'dart:convert';

WhereToWatch whereToWatchFromJson(String str) => WhereToWatch.fromJson(json.decode(str));

String whereToWatchToJson(WhereToWatch data) => json.encode(data.toJson());

class WhereToWatch {
  WhereToWatch({
    this.id,
    this.results,
  });

  int? id;
  WatchResults? results;

  factory WhereToWatch.fromJson(Map<String, dynamic> json) => WhereToWatch(
        id: json["id"],
        results: json["results"] == null ? null : WatchResults.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "results": results?.toJson(),
      };
}

class WatchResults {
  WatchResults({
    this.ae,
    this.ar,
    this.at,
    this.au,
    this.ba,
    this.bb,
    this.be,
    this.bg,
    this.bo,
    this.br,
    this.bs,
    this.ca,
    this.ch,
    this.ci,
    this.cl,
    this.co,
    this.cr,
    this.cz,
    this.de,
    this.dk,
    this.resultsDo,
    this.dz,
    this.ec,
    this.eg,
    this.es,
    this.fi,
    this.fr,
    this.gb,
    this.gf,
    this.gh,
    this.gq,
    this.gt,
    this.hk,
    this.hn,
    this.hr,
    this.hu,
    this.id,
    this.ie,
    this.il,
    this.resultsIn,
    this.iq,
    this.it,
    this.jm,
    this.jp,
    this.ke,
    this.lb,
    this.md,
    this.mk,
    this.mu,
    this.mx,
    this.my,
    this.mz,
    this.ne,
    this.ng,
    this.nl,
    this.no,
    this.nz,
    this.pa,
    this.pe,
    this.ph,
    this.pl,
    this.ps,
    this.pt,
    this.py,
    this.ro,
    this.rs,
    this.sa,
    this.sc,
    this.se,
    this.sg,
    this.si,
    this.sk,
    this.sn,
    this.sv,
    this.th,
    this.tr,
    this.tw,
    this.tz,
    this.ug,
    this.us,
    this.uy,
    this.ve,
    this.za,
    this.zm,
  });

  Ae? ae;
  Ae? ar;
  At? at;
  At? au;
  Ae? ba;
  Ae? bb;
  Ae? be;
  Ae? bg;
  Ae? bo;
  Ae? br;
  Ae? bs;
  At? ca;
  At? ch;
  Ae? ci;
  Ae? cl;
  Ae? co;
  Ae? cr;
  Ae? cz;
  At? de;
  Ae? dk;
  Ae? resultsDo;
  Ae? dz;
  Ae? ec;
  Ae? eg;
  Ae? es;
  Ae? fi;
  At? fr;
  At? gb;
  Ae? gf;
  Ae? gh;
  Ae? gq;
  Ae? gt;
  Ae? hk;
  Ae? hn;
  Ae? hr;
  Ae? hu;
  Ae? id;
  At? ie;
  Ae? il;
  Ae? resultsIn;
  Ae? iq;
  Ae? it;
  Ae? jm;
  At? jp;
  Ae? ke;
  Ae? lb;
  Ae? md;
  Ae? mk;
  Ae? mu;
  Ae? mx;
  Ae? my;
  Ae? mz;
  Ae? ne;
  Ae? ng;
  Ae? nl;
  Ae? no;
  Ae? nz;
  Ae? pa;
  Ae? pe;
  Ae? ph;
  Ae? pl;
  Ae? ps;
  Ae? pt;
  Ae? py;
  Ae? ro;
  Ae? rs;
  Ae? sa;
  Ae? sc;
  Ae? se;
  Ae? sg;
  Ae? si;
  Ae? sk;
  Ae? sn;
  Ae? sv;
  Ae? th;
  Ae? tr;
  Ae? tw;
  Ae? tz;
  Ae? ug;
  Us? us;
  Ae? uy;
  Ae? ve;
  Ae? za;
  Ae? zm;

  factory WatchResults.fromJson(Map<String, dynamic> json) => WatchResults(
        ae: json["AE"] == null ? null : Ae.fromJson(json["AE"]),
        ar: json["AR"] == null ? null : Ae.fromJson(json["AR"]),
        at: json["AT"] == null ? null : At.fromJson(json["AT"]),
        au: json["AU"] == null ? null : At.fromJson(json["AU"]),
        ba: json["BA"] == null ? null : Ae.fromJson(json["BA"]),
        bb: json["BB"] == null ? null : Ae.fromJson(json["BB"]),
        be: json["BE"] == null ? null : Ae.fromJson(json["BE"]),
        bg: json["BG"] == null ? null : Ae.fromJson(json["BG"]),
        bo: json["BO"] == null ? null : Ae.fromJson(json["BO"]),
        br: json["BR"] == null ? null : Ae.fromJson(json["BR"]),
        bs: json["BS"] == null ? null : Ae.fromJson(json["BS"]),
        ca: json["CA"] == null ? null : At.fromJson(json["CA"]),
        ch: json["CH"] == null ? null : At.fromJson(json["CH"]),
        ci: json["CI"] == null ? null : Ae.fromJson(json["CI"]),
        cl: json["CL"] == null ? null : Ae.fromJson(json["CL"]),
        co: json["CO"] == null ? null : Ae.fromJson(json["CO"]),
        cr: json["CR"] == null ? null : Ae.fromJson(json["CR"]),
        cz: json["CZ"] == null ? null : Ae.fromJson(json["CZ"]),
        de: json["DE"] == null ? null : At.fromJson(json["DE"]),
        dk: json["DK"] == null ? null : Ae.fromJson(json["DK"]),
        resultsDo: json["DO"] == null ? null : Ae.fromJson(json["DO"]),
        dz: json["DZ"] == null ? null : Ae.fromJson(json["DZ"]),
        ec: json["EC"] == null ? null : Ae.fromJson(json["EC"]),
        eg: json["EG"] == null ? null : Ae.fromJson(json["EG"]),
        es: json["ES"] == null ? null : Ae.fromJson(json["ES"]),
        fi: json["FI"] == null ? null : Ae.fromJson(json["FI"]),
        fr: json["FR"] == null ? null : At.fromJson(json["FR"]),
        gb: json["GB"] == null ? null : At.fromJson(json["GB"]),
        gf: json["GF"] == null ? null : Ae.fromJson(json["GF"]),
        gh: json["GH"] == null ? null : Ae.fromJson(json["GH"]),
        gq: json["GQ"] == null ? null : Ae.fromJson(json["GQ"]),
        gt: json["GT"] == null ? null : Ae.fromJson(json["GT"]),
        hk: json["HK"] == null ? null : Ae.fromJson(json["HK"]),
        hn: json["HN"] == null ? null : Ae.fromJson(json["HN"]),
        hr: json["HR"] == null ? null : Ae.fromJson(json["HR"]),
        hu: json["HU"] == null ? null : Ae.fromJson(json["HU"]),
        id: json["ID"] == null ? null : Ae.fromJson(json["ID"]),
        ie: json["IE"] == null ? null : At.fromJson(json["IE"]),
        il: json["IL"] == null ? null : Ae.fromJson(json["IL"]),
        resultsIn: json["IN"] == null ? null : Ae.fromJson(json["IN"]),
        iq: json["IQ"] == null ? null : Ae.fromJson(json["IQ"]),
        it: json["IT"] == null ? null : Ae.fromJson(json["IT"]),
        jm: json["JM"] == null ? null : Ae.fromJson(json["JM"]),
        jp: json["JP"] == null ? null : At.fromJson(json["JP"]),
        ke: json["KE"] == null ? null : Ae.fromJson(json["KE"]),
        lb: json["LB"] == null ? null : Ae.fromJson(json["LB"]),
        md: json["MD"] == null ? null : Ae.fromJson(json["MD"]),
        mk: json["MK"] == null ? null : Ae.fromJson(json["MK"]),
        mu: json["MU"] == null ? null : Ae.fromJson(json["MU"]),
        mx: json["MX"] == null ? null : Ae.fromJson(json["MX"]),
        my: json["MY"] == null ? null : Ae.fromJson(json["MY"]),
        mz: json["MZ"] == null ? null : Ae.fromJson(json["MZ"]),
        ne: json["NE"] == null ? null : Ae.fromJson(json["NE"]),
        ng: json["NG"] == null ? null : Ae.fromJson(json["NG"]),
        nl: json["NL"] == null ? null : Ae.fromJson(json["NL"]),
        no: json["NO"] == null ? null : Ae.fromJson(json["NO"]),
        nz: json["NZ"] == null ? null : Ae.fromJson(json["NZ"]),
        pa: json["PA"] == null ? null : Ae.fromJson(json["PA"]),
        pe: json["PE"] == null ? null : Ae.fromJson(json["PE"]),
        ph: json["PH"] == null ? null : Ae.fromJson(json["PH"]),
        pl: json["PL"] == null ? null : Ae.fromJson(json["PL"]),
        ps: json["PS"] == null ? null : Ae.fromJson(json["PS"]),
        pt: json["PT"] == null ? null : Ae.fromJson(json["PT"]),
        py: json["PY"] == null ? null : Ae.fromJson(json["PY"]),
        ro: json["RO"] == null ? null : Ae.fromJson(json["RO"]),
        rs: json["RS"] == null ? null : Ae.fromJson(json["RS"]),
        sa: json["SA"] == null ? null : Ae.fromJson(json["SA"]),
        sc: json["SC"] == null ? null : Ae.fromJson(json["SC"]),
        se: json["SE"] == null ? null : Ae.fromJson(json["SE"]),
        sg: json["SG"] == null ? null : Ae.fromJson(json["SG"]),
        si: json["SI"] == null ? null : Ae.fromJson(json["SI"]),
        sk: json["SK"] == null ? null : Ae.fromJson(json["SK"]),
        sn: json["SN"] == null ? null : Ae.fromJson(json["SN"]),
        sv: json["SV"] == null ? null : Ae.fromJson(json["SV"]),
        th: json["TH"] == null ? null : Ae.fromJson(json["TH"]),
        tr: json["TR"] == null ? null : Ae.fromJson(json["TR"]),
        tw: json["TW"] == null ? null : Ae.fromJson(json["TW"]),
        tz: json["TZ"] == null ? null : Ae.fromJson(json["TZ"]),
        ug: json["UG"] == null ? null : Ae.fromJson(json["UG"]),
        us: json["US"] == null ? null : Us.fromJson(json["US"]),
        uy: json["UY"] == null ? null : Ae.fromJson(json["UY"]),
        ve: json["VE"] == null ? null : Ae.fromJson(json["VE"]),
        za: json["ZA"] == null ? null : Ae.fromJson(json["ZA"]),
        zm: json["ZM"] == null ? null : Ae.fromJson(json["ZM"]),
      );

  Map<String, dynamic> toJson() => {
        "AE": ae?.toJson(),
        "AR": ar?.toJson(),
        "AT": at?.toJson(),
        "AU": au?.toJson(),
        "BA": ba?.toJson(),
        "BB": bb?.toJson(),
        "BE": be?.toJson(),
        "BG": bg?.toJson(),
        "BO": bo?.toJson(),
        "BR": br?.toJson(),
        "BS": bs?.toJson(),
        "CA": ca?.toJson(),
        "CH": ch?.toJson(),
        "CI": ci?.toJson(),
        "CL": cl?.toJson(),
        "CO": co?.toJson(),
        "CR": cr?.toJson(),
        "CZ": cz?.toJson(),
        "DE": de?.toJson(),
        "DK": dk?.toJson(),
        "DO": resultsDo?.toJson(),
        "DZ": dz?.toJson(),
        "EC": ec?.toJson(),
        "EG": eg?.toJson(),
        "ES": es?.toJson(),
        "FI": fi?.toJson(),
        "FR": fr?.toJson(),
        "GB": gb?.toJson(),
        "GF": gf?.toJson(),
        "GH": gh?.toJson(),
        "GQ": gq?.toJson(),
        "GT": gt?.toJson(),
        "HK": hk?.toJson(),
        "HN": hn?.toJson(),
        "HR": hr?.toJson(),
        "HU": hu?.toJson(),
        "ID": id?.toJson(),
        "IE": ie?.toJson(),
        "IL": il?.toJson(),
        "IN": resultsIn?.toJson(),
        "IQ": iq?.toJson(),
        "IT": it?.toJson(),
        "JM": jm?.toJson(),
        "JP": jp?.toJson(),
        "KE": ke?.toJson(),
        "LB": lb?.toJson(),
        "MD": md?.toJson(),
        "MK": mk?.toJson(),
        "MU": mu?.toJson(),
        "MX": mx?.toJson(),
        "MY": my?.toJson(),
        "MZ": mz?.toJson(),
        "NE": ne?.toJson(),
        "NG": ng?.toJson(),
        "NL": nl?.toJson(),
        "NO": no?.toJson(),
        "NZ": nz?.toJson(),
        "PA": pa?.toJson(),
        "PE": pe?.toJson(),
        "PH": ph?.toJson(),
        "PL": pl?.toJson(),
        "PS": ps?.toJson(),
        "PT": pt?.toJson(),
        "PY": py?.toJson(),
        "RO": ro?.toJson(),
        "RS": rs?.toJson(),
        "SA": sa?.toJson(),
        "SC": sc?.toJson(),
        "SE": se?.toJson(),
        "SG": sg?.toJson(),
        "SI": si?.toJson(),
        "SK": sk?.toJson(),
        "SN": sn?.toJson(),
        "SV": sv?.toJson(),
        "TH": th?.toJson(),
        "TR": tr?.toJson(),
        "TW": tw?.toJson(),
        "TZ": tz?.toJson(),
        "UG": ug?.toJson(),
        "US": us?.toJson(),
        "UY": uy?.toJson(),
        "VE": ve?.toJson(),
        "ZA": za?.toJson(),
        "ZM": zm?.toJson(),
      };
}

class Ae {
  Ae({
    this.link,
    this.flatrate,
    this.buy,
    this.free,
  });

  String? link;
  List<Flatrate>? flatrate;
  List<Flatrate>? buy;
  List<Flatrate>? free;

  factory Ae.fromJson(Map<String, dynamic> json) => Ae(
      link: json["link"],
        flatrate: json["flatrate"] == null ? [] : List<Flatrate>.from(json["flatrate"]!.map((x) => Flatrate.fromJson(x))),
        buy: json["buy"] == null ? [] : List<Flatrate>.from(json["buy"]!.map((x) => Flatrate.fromJson(x))),
        free: json["free"] == null ? [] : List<Flatrate>.from(json["free"]!.map((x) => Flatrate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
       "link": link,
        "flatrate": flatrate == null ? [] : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
        "buy": buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
         "free": free == null ? [] : List<dynamic>.from(free!.map((x) => x.toJson())),
      };
}

class Flatrate {
  Flatrate({
    this.logoPath,
    this.providerId,
    this.providerName,
    this.displayPriority,
  });

  String? logoPath;
  int? providerId;
  String? providerName;
  int? displayPriority;

  factory Flatrate.fromJson(Map<String, dynamic> json) => Flatrate(
        logoPath: json["logo_path"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        displayPriority: json["display_priority"],
      );

  Map<String, dynamic> toJson() => {
        "logo_path": logoPath,
        "provider_id": providerId,
        "provider_name": providerName,
        "display_priority": displayPriority,
      };
}

class At {
  At({
    this.link,
    this.flatrate,
    this.buy,
    this.free,
  });

  String? link;
  List<Flatrate>? flatrate;
  List<Flatrate>? buy;
  List<Flatrate>? free;

  factory At.fromJson(Map<String, dynamic> json) => At(
     link: json["link"],
        flatrate: json["flatrate"] == null ? [] : List<Flatrate>.from(json["flatrate"]!.map((x) => Flatrate.fromJson(x))),
        buy: json["buy"] == null ? [] : List<Flatrate>.from(json["buy"]!.map((x) => Flatrate.fromJson(x))),
        free: json["free"] == null ? [] : List<Flatrate>.from(json["free"]!.map((x) => Flatrate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "flatrate": flatrate == null ? [] : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
        "buy": buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
         "free": free == null ? [] : List<dynamic>.from(free!.map((x) => x.toJson())),
      };
}

class Us {
  Us({
    this.link,
    this.flatrate,
    this.free,
    this.buy,
  });

  String? link;
  List<Flatrate>? flatrate;
  List<Flatrate>? buy;
  List<Flatrate>? free;


  factory Us.fromJson(Map<String, dynamic> json) => Us(
        link: json["link"],
        flatrate: json["flatrate"] == null ? [] : List<Flatrate>.from(json["flatrate"]!.map((x) => Flatrate.fromJson(x))),
        buy: json["buy"] == null ? [] : List<Flatrate>.from(json["buy"]!.map((x) => Flatrate.fromJson(x))),
        free: json["free"] == null ? [] : List<Flatrate>.from(json["free"]!.map((x) => Flatrate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
       "link": link,
        "flatrate": flatrate == null ? [] : List<dynamic>.from(flatrate!.map((x) => x.toJson())),
        "buy": buy == null ? [] : List<dynamic>.from(buy!.map((x) => x.toJson())),
         "free": free == null ? [] : List<dynamic>.from(free!.map((x) => x.toJson())),
      };
}

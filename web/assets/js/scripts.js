$( function () {
  // Fancybox
  Fancybox.bind("[data-fancybox]")

  // TEI: <placeName>
  $('.tei-placeName').attr('title', 'Ortsname')
                     .attr('data-bs-toggle', 'tooltip')

  // TEI: <surname>
  $('.tei-surname').attr('title', 'Nachname')
                   .attr('data-bs-toggle', 'tooltip')

  // TEI: <handShift>
  $('.tei-handShift').each( function () {
    let el = $(this)
    el.attr('title', `Handwechsel. Medium: ${el.data('medium')}, Schreiber: ${el.data('scribe')}`)
      .attr('data-bs-toggle', 'tooltip')
  })

  // TEI: <add>
  $('.tei-add').each( function () {
    let el = $(this)
    let place = el.data('place')
    let title
    switch (place) {
      case 'above':
        title = 'interlineare Einfügung darüber'
        break
      case 'below':
        title = 'interlineare Einfügung darunter'
        break
      case 'top':
        title = 'Einfügung am oberen Seitenrand'
        break
      case 'bottom':
        title = 'Einfügung am unteren Seitenrand'
        break
      case 'margin':
        title = 'Einfügung am Rand'
        break
      case 'inline':
        title = 'Einfügung auf der Zeile'
        break
      case 'opposite':
        title = 'Zusatz, der auf anderer Briefseite weitergeht'
        break
      case undefined:
        title = 'Einfügung'
        break
      default:
        title = `Einfügung: ${title}`
    }

    if ( el.data('hand') ) {
      if ( title.length != 0 )
        title += ' '
      title += `; Hand: ${el.data('hand')}`
    }

    el.attr('title', title)
      .attr('data-bs-toggle', 'tooltip')
  })

  // TEI: <pb>, links to page images
  $('.tei-pb[data-facsimile').append( function (i, str) {
    let el = $(this)
    let n         = el.data('n')
    let facs      = el.data('facs')
    let facsimile = el.data('facsimile')
    let href = window.location.href
    let dir  = href.substring(0, href.lastIndexOf('/')).replace(/.*\//,'')
    let src  = `${imgBase}/${dir}/${facsimile}`

    let marginLeft = -( el.position().left - $('.tei').position().left + 220)
    return `<a data-fancybox="gallery-text" data-caption="Seite ${n}" href="${src}" target="_blank" title="Faksimile im Vollbild anzeigen">[Seite ${n}]</a>
            <figure class="tei-side-figure" style="margin-left:${marginLeft}px">
              <a data-fancybox="gallery-side" data-caption="Faksimile ${facs}" href="${src}" target="_blank" title="Faksimile im Vollbild anzeigen">
                <img src="${src}" class="figure-img img-fluid rounded"/>
              </a>
              <figcaption class="figure-caption">Faksimile ${facs}</figcaption>
            </figure>`
  })

  // TEI: <seg ana="#pic">
  $('.tei-seg[data-ana="#pic"]').each( function () {
    let el = $(this)
    el.attr('title', el.html())
      .attr('data-bs-toggle', 'tooltip')
      .attr('data-bs-placement', 'bottom')
      .html('')
  })

  // in narrow texts centered headings and other centered text is displayed
  // to the very left, so we calculate here the average text line width and
  // set the width of the head container to 60 % resp. 70 %
  recalculate_head_width();
  function recalculate_head_width () {
    // not on mobile view
    if ( $(window).width() < 768 )
      return

    $('.tei-body .tei-p').contents().filter( function () {
      return this.nodeType === 3
    }).wrap('<span class="calc-line"/>')

    let line_cnt        = 0
    let line_length     = 0
    let line_max_length = 0
    $('.calc-line').each( function () {
      const width = $(this)[0].getClientRects()[0].width
      line_max_length = width > line_max_length ? width : line_max_length
      if ( width > 200 ) {
        line_cnt++
        line_length += width
      }
    })
    let line_avg = line_length/line_cnt
    if ( line_avg < 300 )
      $('.tei-body .tei-head, .tei-body [data-rendition="#c"], .tei-body .tei-pb').css({ 'width': '60%' })
    else if ( line_avg < 400 )
      $('.tei-body .tei-head, .tei-body [data-rendition="#c"], .tei-body .tei-pb').css({ 'width': '70%' })
    $('.tei-body [data-rendition~="#r"]').css({ 'margin-right': ($('.tei-body').width() - line_max_length) + 'px' })
  }

  // "list.json" lists data as arrays, this is the mapping
  fields = {};
  [
    'dirname',
    'filename',
    'id',
    'institutionShort',
    'institution',
    'record',
    'patient',
    'sex',
    'parents',
    'birthDate',
    'entryDate',
    'leaveDate',
    'deathDate',
    'occupation',
    'residence',
    'familyStatus',
    'subsistenceClass',
    'faith',
    'trait',
    'textType',
    'textSubType',
    'domain',
    'sender',
    'dateSent',
    'dateSentSort',
    'placeSent',
    'addressee',
    'extentPages',
    'extentWords'
  ].forEach( (x, i) => fields[x] = i )

  // expansion for text type abbreviations
  textTypes = {
    pp: 'Privatbrief',
    po: 'offizieller Brief eines Patienten',
    ap: 'Privatbrief von außen',
    ao: 'offizieller Brief von außen',
    so: 'sonstiger Brief'
  }
  $('.copa-text-type').each( function () {
    let el = $(this)
    el.attr('title', textTypes[el.text()])
      .attr('data-bs-toggle', 'tooltip')
  })

  // expansion for institutional abbreviations
  institutions = {
    dor: 'Dortmund-Aplerbeck',
    gut: 'Gütersloh',
    ham: 'Hamburg',
    kfb: 'Kaufbeuren-Irsee',
    len: 'Lengerich-Bethesda',
    lip: 'Lippstadt',
    mrs: 'Marsberg',
    mun: 'Münster',
    war: 'Warstein'
  }
  $('.copa-institution').each( function () {
    let el = $(this)
    el.attr('title', institutions[el.text()])
      .attr('data-bs-toggle', 'tooltip')
  })

  // German localization for Datatables
  let dt_l10n = {
    "sEmptyTable":     "Keine Daten in der Tabelle vorhanden",
    "sInfo":           "_START_ bis _END_ von _TOTAL_ Einträgen",
    "sInfoEmpty":      "0 bis 0 von 0 Einträgen",
    "sInfoFiltered":   "(gefiltert aus _MAX_ Einträgen)",
    "sInfoPostFix":    "",
    "sInfoThousands":  ".",
    "sLengthMenu":     "_MENU_ Einträge anzeigen",
    "sLoadingRecords": "Wird geladen ...",
    "sProcessing":     "<div class='d-flex justify-content-center'><div class='spinner-border' role='status'><span class='visually-hidden'>Bitte warten …</span></div></div>",
    "sSearch":         "Suchen",
    "sZeroRecords":    "Keine Einträge vorhanden.",
    "oPaginate": {
      "sFirst":    "Erste",
      "sPrevious": "Zurück",
      "sNext":     "Nächste",
      "sLast":     "Letzte"
    },
    "oAria": {
      "sSortAscending":  ": aktivieren, um Spalte aufsteigend zu sortieren",
      "sSortDescending": ": aktivieren, um Spalte absteigend zu sortieren"
    },
    "select": {
      "rows": {
        "_": "%d Zeilen ausgewählt",
        "0": "Zum Auswählen auf eine Zeile klicken",
        "1": "1 Zeile ausgewählt"
      }
    }
  }

  // formats an ISO date to show only the year part
  function yearOfDate (date) {
    return date.replace(/-\d+-\d+/,'')
  }

  // slims a residence value
  function formatResidence (str) {
    return str.split(/; /)
              .map( x => x.replace(/((?:Geburts|Wohn)ort): ([^;]+)/, '<span title="$1" data-bs-toggle="tooltip" class="cursor-help">$2</span>') )
              .join('; ')
  }

  // to provide better sorting, this helper function pads
  // all digits with up to 6 zeros as in printf’s "%06d"
  function padId (str) {
    return str.replace( /\d+/g, (m) => { return m.padStart(6, '0') })
  }

  // sorting: empty values always at end
  // via: https://stackoverflow.com/a/29829370
  jQuery.fn.dataTableExt.oSort["empty-last-asc"] = function(a, b) {
    return (!a)-(!b) || +(a>b)||-(a<b);
  }
  jQuery.fn.dataTableExt.oSort["empty-last-desc"] = function(a, b) {
    return (!a)-(!b) || -(a>b)||+(a<b);
  }

  // corpus listing
  var dt_pat = $('#pat-list').DataTable({
    "processing": true,
    "ajax": {
      "url": base + "list.json",
      "cache": true
    },
    "initComplete": function (settings, json) {
      $('[data-bs-toggle="tooltip"]').tooltip()
    },
    "language": dt_l10n,
    "columns": [
      {
        "type": "natural-nohtml",
        "render": {
          "display": function (data, type, row) {
            return `<code><a href="${base}${row[fields.dirname]}/${row[fields.filename]}.html">${row[fields.id]}</a></code>`
          },
          "filter": function (data, type, row) {
            return row[fields.id]
          },
          "sort": function (data, type, row) {
            return padId(row[fields.id])
          }
        }
      },
      {
        "render": function (data, type, row) {
          return row[fields.patient]
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          return yearOfDate(row[fields.birthDate])
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          return yearOfDate(row[fields.entryDate])
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          let ret = yearOfDate(row[fields.leaveDate])
          if ( row[fields['deathDate']] != '-' )
            ret += '<span title="Tod in Anstalt" data-bs-toggle="tooltip" class="cursor-help"><sup>†</sup></span>'
          return ret
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.subsistenceClass].replace(/\D/g, '')
        },
      },
      {
        "type": "empty-last",
        "className": "text-hyph",
        "render": function (data, type, row) {
          return row[fields.occupation]
        }
      },
      {
        "className": "text-hyph",
        "render": function (data, type, row) {
          return formatResidence(row[fields.residence])
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.familyStatus].replace(/^k\.\sA\.$/, '')
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.faith]
        }
      },
      {
        "render": function (data, type, row) {
          return `<abbr title="${textTypes[row[fields.textType]]}" data-bs-toggle="tooltip">${row[fields.textType]}</abbr>`
        }
      },
      {
        "render": function (data, type, row) {
          return row[fields.sender]
        }
      },
      {
        "render": {
          "display": function (data, type, row) {
            return row[fields.dateSent]
          },
          "sort": function (data, type, row) {
            return row[fields.dateSentSort]
          }
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.placeSent]
        }
      },
      {
        "className": "text-nowrap",
        "orderable": false,
        "render": function (data, type, row) {
          return `${row[fields.extentPages]} S., ca. ${row[fields.extentWords]} W.`
        }
      },
    ]
  })

  // double-click on corpus listing row opens text
  $('#pat-list tbody').on('dblclick', 'tr', function () {
    let data = dt_pat.row( this ).data()
    let target = `${base}${data[fields.dirname]}/${data[fields.filename]}.html`
    window.location.href = target
  })

  // records listing
  var dt_rec = $('#record-list').DataTable({
    "processing": true,
    "ajax": {
      "url": base + "list.json",
      "cache": true,
      "dataSrc": function (json) {
        let ret  = new Array()
        let seen = new Array()
        let tt   = new Array()
        for ( var i of json.data) {
          let key = i[fields.institutionShort] + '-' + i[fields.record]
          if ( seen[key] === undefined )
            seen[key] = {
              "cnt": 0,
              "tt": new Set(),
            }

          seen[key].cnt++;
          seen[key]['tt'].add( i[fields.textType] )
          if ( seen[key].cnt > 1 )
            continue
          ret.push(i)
        }
        for ( var i of ret ) {
          let key = i[fields.institutionShort] + '-' + i[fields.record]
          i.push( seen[key].cnt, seen[key].tt )
        }
        return ret
      }
    },
    "initComplete": function (settings, json) {
      $('[data-bs-toggle="tooltip"]').tooltip()
      // open record if URL has a hash value
      let wantRecord = document.location.hash.match(/^(#[a-z]{3}-.*)/)
      if ( wantRecord != null && $('a[href="' + wantRecord[0] + '"]').length ) {
        showRecord( $('a[href="' + wantRecord[0] + '"]').first() )
      }
    },
    "language": dt_l10n,
    "columns": [
      {
        "render": {
          "display": function (data, type, row) {
            return `<abbr title="${institutions[row[fields.institutionShort]]}" data-bs-toggle="tooltip">${row[fields.institutionShort]}</abbr>`
          },
          "filter": function (data, type, row) {
            return institutions[row[fields.institutionShort]]
          },
          "sort": function (data, type, row) {
            return `${row[fields.institutionShort]}-${padId(row[fields.record])}`
          }
        }
      },
      {
        "className": "text-nowrap",
        "render": {
          "display": function (data, type, row) {
            return `<a href="#${encodeURIComponent(row[fields.institutionShort])}-${encodeURIComponent(row[fields.record])}" class="copa-record" data-institution="${row[fields.institutionShort]}" data-record="${row[fields.record]}" style="cursor:pointer">${row[fields.record]}</a>`
          },
          "filter": function (data, type, row) {
            return row[fields.record]
          },
          "sort": function (data, type, row) {
            return `${row[fields.institutionShort]}-${padId(row[fields.record])}`
          }
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          return row[fields.patient]
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          return yearOfDate(row[fields.birthDate])
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          return yearOfDate(row[fields.entryDate])
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          let ret = yearOfDate(row[fields.leaveDate])
          if ( row[fields['deathDate']] != '-' )
            ret += '<span title="Tod in Anstalt" data-bs-toggle="tooltip" class="cursor-help"><sup>†</sup></span>'
          return ret
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.subsistenceClass].replace(/\D/g, '')
        },
      },
      {
        "type": "empty-last",
        "className": "text-hyph",
        "render": function (data, type, row) {
          return row[fields.occupation]
        }
      },
      {
        "className": "text-hyph",
        "render": function (data, type, row) {
          return formatResidence( row[fields.residence] )
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.familyStatus].replace(/^k\.\sA\.$/, '')
        }
      },
      {
        "type": "empty-last",
        "render": function (data, type, row) {
          return row[fields.faith]
        }
      },
      {
        "className": "text-nowrap",
        "render": function (data, type, row) {
          return Array.from(row[row.length - 1]).map(x => `<abbr title="${textTypes[x]}" data-bs-toggle="tooltip">${x}</abbr>`).join(', ')
        }
      },
      {
        "className": "text-end",
        "render": function (data, type, row) {
          return row[row.length - 2]
        }
      }
    ]
  })

  // open record
  $(document).on('click', 'a.copa-record', function () {
    showRecord( $(this) )
    return false
  })

  window.addEventListener('hashchange', function () {
    if ( !document.location.hash || document.location.hash == '#' ) {
      $('#copa-record').hide()
      $('#copa-list').show()
      return
    }
    let wantRecord = document.location.hash.match(/^(#[a-z]{3}-.*)/)
    if ( wantRecord != null && $('a[href="' + wantRecord[0] + '"]').length )
      showRecord( $('a[href="' + wantRecord[0] + '"]').first() )
  })

  function showRecord (el) {
    let record = dt_rec.rows().data().toArray().filter(row => row[fields.institutionShort] == el.data('institution') && row[fields.record] == el.data('record') )[0]
    $('[data-field]').each( function () {
      let field = $(this).data('field')
      let content = record[fields[field]]
      if ( field == 'leaveDate' && record[fields['deathDate']] != '-' )
        content += '<span title="Tod in Anstalt" data-bs-toggle="tooltip" class="cursor-help"><sup>†</sup></span>'
      $(this).html( content )
    })
    history.pushState({ "foo": "bar"}, "Detailansicht Patientenakte" )
    document.location.hash = el.attr('href')
    $.get( base + "list.json", function (data) {
      let filtered = data.data.filter( row => row[fields.institutionShort] == el.data('institution') && row[fields.record] == el.data('record') )
      var dt_rec_single = $('#record-list-single').DataTable({
        "destroy": true,
        "processing": true,
        "data": filtered,
        "initComplete": function (settings, json) {
          $('[data-bs-toggle="tooltip"]').tooltip()
          if (this.api().page.info().pages === 1)
            $('#record-list-single_length, #record-list-single_info, #record-list-single_paginate').hide()
        },
        "language": dt_l10n,
        "columns": [
          {
            "type": "natural-nohtml",
            "render": {
              "display": function (data, type, row) {
                return `<code><a href="${base}${row[fields.dirname]}/${row[fields.filename]}.html">${row[fields.id]}</a></code>`
              },
              "filter": function (data, type, row) {
                return row[fields.id]
              },
              "sort": function (data, type, row) {
                return padId(row[fields.id])
              }
            }
          },
          {
            "render": function (data, type, row) {
              let ret = `<abbr title="${textTypes[row[fields.textType]]}" data-bs-toggle="tooltip">${row[fields.textType]}</abbr>`
              let domain_short = row[fields.domain].replace(/^(?:offizieller|privater|sonstiger)(?:\/(?:offizieller|privater|sonstiger))? Brief(\s*(?:[:,–-]|und)\s*)?/, '')
                                                   .replace(/^\s*\((.*)\)$/, '$1')
              if ( domain_short.length ) {
                ret += ` (${domain_short})`
              }
              return ret
            }
          },
          {
            "render": function (data, type, row) {
              return row[fields.sender]
            }
          },
          {
            "render": function (data, type, row) {
              return row[fields.addressee]
            }
          },
          {
            "render": {
              "display": function (data, type, row) {
                return row[fields.dateSent]
              },
              "sort": function (data, type, row) {
                return row[fields.dateSentSort]
              }
            }
          },
          {
            "type": "empty-last",
            "render": function (data, type, row) {
              return row[fields.placeSent]
            }
          },
          {
            "className": "text-nowrap",
            "orderable": false,
            "render": function (data, type, row) {
              return `${row[fields.extentPages]} S., ca. ${row[fields.extentWords]} W.`
            }
          },
        ]
      })
      $('#copa-record').show()
      $('#copa-list').hide()
      $('html, body').animate({scrollTop: '0px'}, 100)
    })
  }

  // close record button
  $(document).on('click', '#copa-record-close', function () {
    // remove hash fragment from window.location
    history.pushState("", document.title, window.location.pathname + window.location.search)
    $('#copa-record').hide()
    $('#copa-list').show()
    $('html, body').animate({scrollTop: '0px'}, 100)
  })

  // initialize bootstrap’s tooltips
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
})

$( function () {
  // search
  $('#search-error').hide()

  let searchParams = new URLSearchParams(window.location.search)
  let q = searchParams.get('q')
  if ( q && q.replace(/^\s+|\s+$/,'').length > 0 ) {
    $('#search-in-progress').show()

    $('#q').val(q)
    $('#q-wrapper').val(q)
    let qf = q

    // date range
    let ds = searchParams.get('ds')
    let de = searchParams.get('de')
    if ( ds )
      $('#ds').val(ds)
    if ( de )
      $('#de').val(de)

    ds = $('#ds').val()
    de = $('#de').val()
    if ( ds && de )
      qf += ` #asc_date[${ds},${de}]`

    // context
    let cntxt = searchParams.get('cntxt')
    if ( cntxt )
      $('#cntxt').val(cntxt)

    cntxt = $('#cntxt').val()
    if ( cntxt )
      qf += ` #cntxt ${cntxt}`

    // within
    let within = searchParams.get('within')
    if ( within )
      $('#within').val(within)

    within = $('#within').val()
    if ( within == 'sep' )
      qf += ` #${within}`
    else if ( within == 'file' )
      qf += ' #within file'

    // console.log('DDC query:', qf)

    // paging
    let limit = parseInt(searchParams.get('limit')) || $('#limit').val() || 20
    let page  = parseInt(searchParams.get('p'))     || 1
    let start = (page - 1) * limit + 1

    function page_state (p, s) {
      let ret = ''
      if ( !s || s < 1 || s > p.last_page() )
        ret += ' disabled'
      if ( s == p.current_page)
        ret += ' active'
      return ret
    }

    function result_url (page) {
      let url = new URL(window.location.href)
      url.searchParams.set('p', page)
      return url.toString()
    }

    let dstar = 'https://kaskade.dwds.de/dstar/copadocs/dstar.perl' // does not exist yet
    $.ajax({
      url: dstar,
      data: { q: qf, fmt: 'json', limit: limit, start: start },
    }).done( function (data) {
      let head = '<div class="result-head mb-2 text-center">'
      if ( data.nhits_ )
        head += `${parseInt(data.start) + 1}–${data.end_} von ${data.nhits_} Treffern`
      else
        head += 'keine Treffer gefunden'
      head += '</div>'

      const p = new Pager()
      p.total_entries    = data.nhits_
      p.entries_per_page = limit
      p.current_page     = parseInt((start / limit) + 1)

      let pager = `
<nav>
  <ul class="pagination pagination-sm justify-content-center">
    <li class="page-item ${page_state(p, p.first_page())}">
      <a class="page-link" href="${result_url(p.first_page())}">&#x21e4;</a>
    </li>
    <li class="page-item ${page_state(p, p.current_page - 10)}">
      <a class="page-link" href="${result_url(p.current_page - 10)}">-10</a>
    </li>
    <li class="page-item ${page_state(p, p.current_page - 5)}">
      <a class="page-link" href="${result_url(p.current_page - 5)}">-5</a>
    </li>
    <li class="page-item ${page_state(p, p.previous_page())}">
      <a class="page-link" href="${result_url(p.previous_page())}">&larr;</a>
    </li>`

    let page_leftmost = (p.current_page || 0) - 2
    if ( (page_leftmost || 0) < 1 )
      page_leftmost = 1

    if ( p.last_page() - (page_leftmost || 0) < 5 )
      page_leftmost = p.last_page() - 4

    let page_rightmost = p.current_page + 2
    if ( (page_rightmost || 0) < 5 )
      page_rightmost = 5

    if ( (page_rightmost || 0) > p.last_page() )
      page_rightmost = p.last_page()

    for ( let i = page_leftmost; i <= page_rightmost; i++ ) {
      if ( (i || 0) < 1 )
        continue
      if ( i > p.last_page() )
        continue

      pager += `
      <li class="page-item ${page_state(p, i)}">
        <a class="page-link" href="${result_url(i)}">${i}</a>
      </li>`
    }

    pager += `
    <li class="page-item ${page_state(p, p.next_page())}">
      <a class="page-link" href="${result_url(p.next_page())}">&rarr;</a>
    </li>
    <li class="page-item ${page_state(p, p.current_page + 5)}">
      <a class="page-link" href="${result_url(p.current_page + 5)}">+5</a>
    </li>
    <li class="page-item ${page_state(p, p.current_page + 10)}">
      <a class="page-link" href="${result_url(p.current_page + 10)}">+10</a>
    </li>
    <li class="page-item ${page_state(p, p.last_page())}">
      <a class="page-link" href="${result_url(p.last_page())}">&#x21e5;</a>
    </li>
  </ul>
</nav>`

      let hits = []
      data.hits_.forEach( (h,i) => {
        let ctx_before = ctxString(h.ctx_[0])
        let ctx_after  = ctxString(h.ctx_[2])
        let fragment = h.ctx_[1].map( (k,i) => (i!=0 && k.ws==1 ? ' ' : '') + _h(k.w) ).slice(0, 3).join('')
        let div = `
<div class="hit mb-3">
  <div class="hit-bibl">
    <span class="hit-no">${parseInt(data.start) + i + 1}.</span>
    <a href="articles/${_u(_h(h.meta_.basename.replace(/\.orig$/,'')))}.html#:~:text=${_u(_h(fragment))}">${_h(h.meta_.bibl)}</a>
  </div>
`

        if ( within != 'file' ) {
          div += `
  <div class="hit-text">
    ${ ctx_before }
    ${ h.ctx_[1].map( (k,i) => (i!=0 && k.ws==1 ? ' ' : '') + (k.hl_==1 ? '<b>' : '') + _h(k.w) + (k.hl_==1 ? '</b>' : '') ).join('') }
    ${ ctx_after }
  </div>
          `
        }

        div += `
</div>`
        hits.push( div)
      })
      $('#search-in-progress').hide()
      $('#results').html( head + (data.nhits_ ? pager : '') + hits.join('') + (data.nhits_ ? pager : '') )
    }).fail( function (a, b, c) {
      $('#search-in-progress').hide()
      let msg = a.responseText.match(/<pre>(.*?)<\/pre>/s)
      $('#search-error').html( msg[1] ).show()
    })
  }

  function ctxString (words) {
    let str = ctxWrapTokens(words)
    str = ctxUntokenize(str)
    str = ctxUnwrapTokens(str)
    return str
  }

  function ctxWrapTokens (words) {
    let str = words.map( w => " \x02" + w + "\x03" ).join('')
    str = str.replace(/^ /, '')
    return str
  }

  function ctxUntokenize (str) {
    // token markers left + right
    const wl = '\\x02'
    const wr = '\\x03'

    // quotations marks left
    const ql = '[\\(\\[\\{\\x2018\\x201c\\x2039\\x201a\\x201e]'

    // quotations marks right
    const qr  = '[\\)\\]\\}\\x2019\\x201d\\x203a]'
    // no-quotation marks right
    const nqr = '[^\\)\\]\\}\\x2019\\x201d\\x203a]'

    // generic quotations marks
    const qq  = '["`\'\\xab\\xbb]'
    // generic no-quotations marks
    const nqq = '[^"`\'\\xab\\xbb]'

    // punctuation (right side)
    const pr = '[,.!?:;%]|[\\x2019\\x201d\\x203a][snm]'

    str = str.replace( new RegExp(`(\\s${wl}${qq}+${wr})\\s(${nqq}*)\\s(${wl}${qq}+${wr}\\s)`, "sg"), '$1$2$3' )
    str = str.replace( new RegExp(`(\\s${wl}${ql}${wr})\\s`, "sg"), '$1' )
    str = str.replace( new RegExp(`\\s(${wl}${qr}${wr}\\s)`, "sg"), '$1' )
    str = str.replace( new RegExp(`\\s(${wl}${pr}${wr}\\s)`, "sg"), '$1' )
    return str
  }

  function ctxUnwrapTokens (str) {
    return str.replace( /[\x02\x03]/g, '' )
  }

  // escape HTML
  function _h (str) {
    return document.createElement('div').appendChild(document.createTextNode(str)).parentNode.innerHTML
  }

  // escape URI
  function _u (str) {
    return encodeURIComponent(str)
  }
})

class Pager {
  total_entries
  entries_per_page
  current_page

  first_page() { return 1 }

  last_page() {
    let pages = this.total_entries / this.entries_per_page
    let last_page
    if ( pages == parseInt(pages) )
      last_page = pages
    else
      last_page = 1 + parseInt(pages)
    if ( last_page < 1 )
      last_page = 1
    return last_page
  }

  previous_page() {
    if ( this.current_page > 1 )
      return this.current_page - 1
    else
      return
  }

  next_page() {
    if ( this.current_page < this.last_page() ) {
      return this.current_page + 1
    }
    else
      return
  }
}

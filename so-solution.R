library(httr)
library(rvest)
library(dplyr)
library(V8)

ctx <- v8() # we need this to eval some javascript

# Prime Cookies -----------------------------------------------------------

res <- httr::GET("https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1")
httr::cookies(res)

pg <- httr::content(res)

html_node(pg, xpath=".//script[contains(., '_monsido')]") %>%
  html_text() %>%
  ctx$eval()

monsido_token <- ctx$get("_monsido")[1,2]

# searchlist --------------------------------------------------------------

httr::VERB(
  verb = "POST", url = "https://www.ecan.govt.nz/data/document-library/searchlist",
  httr::add_headers(
    Referer = "https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1",
    `X-Requested-With` = "XMLHttpRequest",
    TE = "Trailers"
  ), httr::set_cookies(
    monsido = monsido_token
  ),
  body = list(
    name = "CRC000002.1",
    pageSize = "999999"
  ),
  encode = "form"
) -> res

httr::content(res)

# Consent Overview --------------------------------------------------------

httr::GET(
  url = "https://www.ecan.govt.nz/data/consent-search/consentoverview/CRC000002.1",
  httr::add_headers(
    Referer = "https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1",
    Authority = "www.ecan.govt.nz",
    `X-Requested-With` = "XMLHttpRequest"
  ),
  httr::set_cookies(
    monsido = monsido_token
  )
) -> res

httr::content(res) %>%
  html_table() %>%
  glimpse()

# Consent Conditions ------------------------------------------------------

httr::GET(
  url = "https://www.ecan.govt.nz/data/consent-search/consentconditions/CRC000002.1",
  httr::add_headers(
    Referer = "https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1",
    Authority = "www.ecan.govt.nz",
    `X-Requested-With` = "XMLHttpRequest"
  ),
  httr::set_cookies(
    monsido = monsido_token
  )
) -> res

httr::content(res) %>%
  as.character() %>%
  substring(1, 300) %>%
  cat()

# Consent Related ---------------------------------------------------------

httr::GET(
  url = "https://www.ecan.govt.nz/data/consent-search/consentrelated/CRC000002.1",
  httr::add_headers(
    Referer = "https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1",
    Authority = "www.ecan.govt.nz",
    `X-Requested-With` = "XMLHttpRequest"
  ),
  httr::set_cookies(
    monsido = monsido_token
  )
) -> res

httr::content(res) %>%
  as.character() %>%
  substring(1, 300) %>%
  cat()

# Workflow ----------------------------------------------------------------

httr::GET(
  url = "https://www.ecan.govt.nz/data/consent-search/consentworkflow/CRC000002.1",
  httr::add_headers(
    Referer = "https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1",
    Authority = "www.ecan.govt.nz",
    `X-Requested-With` = "XMLHttpRequest"
  ),
  httr::set_cookies(
    monsido = monsido_token
  )
) -> res

httr::content(res)

# Consent Flow Restrictions -----------------------------------------------

httr::GET(
  url = "https://www.ecan.govt.nz/data/consent-search/consentflowrestrictions/CRC000002.1",
  httr::add_headers(
    Referer = "https://www.ecan.govt.nz/data/consent-search/consentdetails/CRC000002.1",
    Authority = "www.ecan.govt.nz",
    `X-Requested-With` = "XMLHttpRequest"
  ),
  httr::set_cookies(
    monsido = monsido_token
  )
) -> res

httr::content(res) %>%
  as.character() %>%
  substring(1, 300) %>%
  cat()

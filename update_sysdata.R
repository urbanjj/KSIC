load("data/ksicDB.rda")

ksicDB_C9_codes <- ksicDB[ksicDB$ksic_C == "C9", "cd"]
ksicDB_C10_codes <- ksicDB[ksicDB$ksic_C == "C10", "cd"]

save(ksicDB_C9_codes, ksicDB_C10_codes, file = "R/sysdata.rda")


# Prediction

predictRanger <- function(y, fit, newdata, out_folder, n_threads = 16) {

    predict(
        fit,
        data = newdata,
        predict.all = FALSE,
        type = "response",
        se.method = "infjack",
        num.threads = n_threads,
        verbose = TRUE
        ) ->
        pred_ranger

    names(pred_ranger)

    pred_dt <- data.table(pred_ranger$survival)
    pred_dt$cell <- newdata$cell
    pred_dt$year <- y

    pred_dt |> fwrite(paste0(out_folder, "pred_", y, ".csv"))

}


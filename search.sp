dashboard "search" {

  title = "Benchmark explorer: search the results"

  container {
  
    input "search_term" {
      width = 4
      title = "search term"
      type = "text"
      placeholder = "search term"
    }

    container {

      table {
        args = [self.input.search_term]
        sql = <<EOQ
        select  status, resource, title as benchmark, control_title, control_description
        from cis_v200
        where 
          title ~* $1 or
          control_title ~* $1 or
          control_description ~* $1 or
          reason ~* $1

        EOQ
        column "control_description" {
          wrap = "all"
        }

      }

    }

  }

}

input "reason_base" {
  sql = <<EOQ
    select distinct 
      reason as label,
      reason as value
    from cis_v200
    order by reason
  EOQ
}


dashboard "search" {

  title = "Benchmark explorer: search the results"

  card {
    width = 2
    sql = "select distinct (regexp_match(group_id, 'aws_thrifty'))[1] as mod from csv.benchmarks;"
  }

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
        select  status, resource, reason, title as benchmark, control_title, control_description
        from cis_v200
        where 
          title ~* $1 or
          control_title ~* $1 or
          control_description ~* $1 or
          reason ~* $1

        EOQ
        column "resource" {
          wrap = "all"
        }
        column "reason" {
          wrap = "all"
        }
        column "control_title" {
          wrap = "all"
        }
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


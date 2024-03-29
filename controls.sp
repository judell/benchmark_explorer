dashboard "controls" {

  title = "Benchmark explorer: explore results by control"

  card {
    width = 2
    sql = "select distinct (regexp_match(group_id, 'aws_thrifty'))[1] as mod from csv.benchmarks;"
  }


  container {
    title = "controls"
    
    chart {
      type  = "donut"
      width = 8
      sql   = <<EOQ
          select control_title, count(*) 
          from csv.benchmarks
          group by control_title
          order by count
        EOQ
    }

    container {

      input "control" {
        title = "control"
        width = 4
        sql   = <<EOQ
            select distinct
              control_title as label,
              control_title as value
            from csv.benchmarks
            order by control_title
          EOQ
      }

    }

    container {
  
      table {
        args = [self.input.control] #, self.input.status]
        sql  = <<EOQ
            select resource, title as benchmark, status, reason, account_id, region
            from csv.benchmarks 
            where control_title = $1
          EOQ
        column "control_title" {
          wrap = "all"
        }
      }
    }

  }


}
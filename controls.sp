dashboard "controls" {

  title = "Benchmark explorer: explore results by control"


  container {
    title = "controls"
    
    chart {
      type  = "donut"
      width = 8
      sql   = <<EOQ
          select control_title, count(*) 
          from cis_v200
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
            from cis_v200
            order by control_title
          EOQ
      }

/*
      input "status" {
        width = 4
        title = "status"
        sql   = <<EOQ
            select distinct 
              status as label,
              status as value
            from cis_v200
            order by status
          EOQ
      }
  */

    }

    container {
  
      table {
        args = [self.input.control] #, self.input.status]
        sql  = <<EOQ
            select resource, title as benchmark, status, account_id, region
            from cis_v200 
            where control_title = $1
          EOQ
        column "control_title" {
          wrap = "all"
        }
      }
    }

  }


}